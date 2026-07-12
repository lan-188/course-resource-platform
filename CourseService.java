package com.software.testing.coursemodule.service;

import com.software.testing.common.Result;
import com.software.testing.coursemodule.dto.CourseDTO;

import java.util.List;

public interface CourseService {
    Result<?> createCourse(CourseDTO courseDTO, Long teacherId);
    Result<?> updateCourse(Long courseId, CourseDTO courseDTO);
    Result<?> deleteCourse(Long courseId);
    Result<?> getCourseDetail(Long courseId);
    Result<?> listCourses(Long teacherId);
    // 管理员查看所有课程
    Result<?> listAllCourses();
    // 教师分配学生到课程
    Result<?> assignStudents(Long courseId, List<Long> studentIds);
    // 教师查看课程已分配的学生
    Result<?> getCourseStudents(Long courseId);
    // 教师移除课程中的学生
    Result<?> removeStudent(Long courseId, Long studentId);
    // 学生查看自己被分配的课程
    Result<?> listStudentCourses(Long studentId);
    // 查询所有学生列表（供教师分配用）
    Result<?> listAllStudents();
}
