package com.software.testing.coursemodule.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.software.testing.common.Result;
import com.software.testing.coursemodule.dto.CourseDTO;
import com.software.testing.coursemodule.entity.Course;
import com.software.testing.coursemodule.entity.CourseFile;
import com.software.testing.coursemodule.entity.CourseStudent;
import com.software.testing.coursemodule.mapper.CourseFileMapper;
import com.software.testing.coursemodule.mapper.CourseMapper;
import com.software.testing.coursemodule.mapper.CourseStudentMapper;
import com.software.testing.coursemodule.service.CourseService;
import com.software.testing.usermodule.entity.User;
import com.software.testing.usermodule.mapper.UserMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class CourseServiceImpl implements CourseService {

    private static final Logger log = LoggerFactory.getLogger(CourseServiceImpl.class);

    @Autowired
    private CourseMapper courseMapper;

    @Autowired
    private CourseStudentMapper courseStudentMapper;

    @Autowired
    private CourseFileMapper courseFileMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    public Result<?> createCourse(CourseDTO courseDTO, Long teacherId) {
        log.info("[创建课程] courseName={}, teacherId={}", courseDTO.getCourseName(), teacherId);
        Course course = new Course();
        course.setCourseName(courseDTO.getCourseName());
        course.setDescription(courseDTO.getDescription());
        course.setTeacherId(teacherId);
        courseMapper.insert(course);
        // 填充教师姓名
        fillTeacherName(course);
        log.info("[创建课程成功] id={}, name={}, teacher={}", course.getId(), course.getCourseName(), course.getTeacherName());
        return Result.success("创建成功", course);
    }

    @Override
    public Result<?> updateCourse(Long courseId, CourseDTO courseDTO) {
        log.info("[更新课程] id={}, name={}", courseId, courseDTO.getCourseName());
        Course course = courseMapper.selectById(courseId);
        if (course == null) {
            log.warn("[课程不存在] id={}", courseId);
            return Result.error("课程不存在");
        }
        course.setCourseName(courseDTO.getCourseName());
        course.setDescription(courseDTO.getDescription());
        courseMapper.updateById(course);
        // 填充教师姓名
        fillTeacherName(course);
        log.info("[更新课程成功] id={}", courseId);
        return Result.success("更新成功", course);
    }

    @Override
    public Result<?> deleteCourse(Long courseId) {
        log.info("[删除课程] id={}", courseId);
        // 删除课程资源文件（物理文件 + DB记录）
        List<CourseFile> files = courseFileMapper.selectList(
                new LambdaQueryWrapper<CourseFile>().eq(CourseFile::getCourseId, courseId));
        for (CourseFile f : files) {
            try {
                Files.deleteIfExists(Paths.get(f.getFilePath()));
            } catch (IOException e) {
                log.warn("[删除资源文件失败] path={}", f.getFilePath());
            }
        }
        courseFileMapper.delete(new LambdaQueryWrapper<CourseFile>().eq(CourseFile::getCourseId, courseId));
        // 同时删除关联的学生分配记录
        courseStudentMapper.delete(new LambdaQueryWrapper<CourseStudent>()
                .eq(CourseStudent::getCourseId, courseId));
        courseMapper.deleteById(courseId);
        log.info("[删除课程成功] id={}", courseId);
        return Result.success("删除成功", null);
    }

    @Override
    public Result<?> getCourseDetail(Long courseId) {
        log.info("[查询课程详情] id={}", courseId);
        Course course = courseMapper.selectById(courseId);
        if (course == null) {
            log.warn("[课程不存在] id={}", courseId);
            return Result.error("课程不存在");
        }
        fillTeacherName(course);
        return Result.success(course);
    }

    @Override
    public Result<?> listCourses(Long teacherId) {
        log.info("[查询课程列表] teacherId={}", teacherId);
        List<Course> courses = courseMapper.selectList(new LambdaQueryWrapper<Course>()
                .eq(Course::getTeacherId, teacherId)
                .orderByDesc(Course::getCreateTime));
        // 批量填充教师姓名
        fillTeacherNames(courses);
        log.info("[查询课程列表结果] count={}", courses.size());
        return Result.success(courses);
    }

    @Override
    public Result<?> assignStudents(Long courseId, List<Long> studentIds) {
        log.info("[分配学生到课程] courseId={}, studentCount={}", courseId, studentIds.size());
        Course course = courseMapper.selectById(courseId);
        if (course == null) {
            return Result.error("课程不存在");
        }
        for (Long studentId : studentIds) {
            // 检查是否已分配
            Long count = courseStudentMapper.selectCount(new LambdaQueryWrapper<CourseStudent>()
                    .eq(CourseStudent::getCourseId, courseId)
                    .eq(CourseStudent::getStudentId, studentId));
            if (count == 0) {
                CourseStudent cs = new CourseStudent();
                cs.setCourseId(courseId);
                cs.setStudentId(studentId);
                courseStudentMapper.insert(cs);
            }
        }
        log.info("[分配学生成功] courseId={}, count={}", courseId, studentIds.size());
        return Result.success("分配成功", null);
    }

    @Override
    public Result<?> getCourseStudents(Long courseId) {
        log.info("[查询课程学生] courseId={}", courseId);
        List<CourseStudent> csList = courseStudentMapper.selectList(
                new LambdaQueryWrapper<CourseStudent>().eq(CourseStudent::getCourseId, courseId));
        List<Long> studentIds = csList.stream().map(CourseStudent::getStudentId).collect(Collectors.toList());
        if (studentIds.isEmpty()) {
            return Result.success(new ArrayList<>());
        }
        List<User> students = userMapper.selectBatchIds(studentIds);
        // 隐藏密码
        students.forEach(s -> s.setPassword(null));
        return Result.success(students);
    }

    @Override
    public Result<?> removeStudent(Long courseId, Long studentId) {
        log.info("[移除课程学生] courseId={}, studentId={}", courseId, studentId);
        courseStudentMapper.delete(new LambdaQueryWrapper<CourseStudent>()
                .eq(CourseStudent::getCourseId, courseId)
                .eq(CourseStudent::getStudentId, studentId));
        return Result.success("移除成功", null);
    }

    @Override
    public Result<?> listStudentCourses(Long studentId) {
        log.info("[学生查询课程] studentId={}", studentId);
        List<CourseStudent> csList = courseStudentMapper.selectList(
                new LambdaQueryWrapper<CourseStudent>().eq(CourseStudent::getStudentId, studentId));
        if (csList.isEmpty()) {
            return Result.success(new ArrayList<>());
        }
        List<Long> courseIds = csList.stream().map(CourseStudent::getCourseId).collect(Collectors.toList());
        List<Course> courses = courseMapper.selectBatchIds(courseIds);
        // 批量填充教师姓名
        fillTeacherNames(courses);
        return Result.success(courses);
    }

    @Override
    public Result<?> listAllStudents() {
        log.info("[查询所有学生]");
        List<User> students = userMapper.selectList(new LambdaQueryWrapper<User>()
                .eq(User::getRole, "STUDENT")
                .orderByAsc(User::getStudentNo));
        students.forEach(s -> s.setPassword(null));
        return Result.success(students);
    }

    @Override
    public Result<?> listAllCourses() {
        log.info("[管理员查询所有课程]");
        List<Course> courses = courseMapper.selectList(new LambdaQueryWrapper<Course>()
                .orderByDesc(Course::getCreateTime));
        // 批量填充教师姓名
        fillTeacherNames(courses);
        log.info("[管理员查询所有课程结果] count={}", courses.size());
        return Result.success(courses);
    }

    // ========== 辅助方法：填充教师姓名 ==========

    /** 为单个课程填充教师姓名 */
    private void fillTeacherName(Course course) {
        if (course == null || course.getTeacherId() == null) return;
        User teacher = userMapper.selectById(course.getTeacherId());
        if (teacher != null) {
            course.setTeacherName(teacher.getRealName() != null ? teacher.getRealName() : teacher.getUsername());
        }
    }

    /** 为课程列表批量填充教师姓名 */
    private void fillTeacherNames(List<Course> courses) {
        if (courses == null || courses.isEmpty()) return;
        // 收集所有 teacherId
        Set<Long> teacherIds = courses.stream()
                .map(Course::getTeacherId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        if (teacherIds.isEmpty()) return;
        // 批量查询教师信息
        List<User> teachers = userMapper.selectBatchIds(teacherIds);
        Map<Long, String> teacherNameMap = new HashMap<>();
        for (User t : teachers) {
            teacherNameMap.put(t.getId(), t.getRealName() != null ? t.getRealName() : t.getUsername());
        }
        // 填充
        for (Course c : courses) {
            String name = teacherNameMap.get(c.getTeacherId());
            if (name != null) {
                c.setTeacherName(name);
            }
        }
    }
}
