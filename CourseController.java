package com.software.testing.coursemodule.controller;

import com.software.testing.common.Result;
import com.software.testing.coursemodule.dto.CourseDTO;
import com.software.testing.coursemodule.service.CourseFileService;
import com.software.testing.coursemodule.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/course")
public class CourseController {

    @Autowired
    private CourseService courseService;

    @Autowired
    private CourseFileService courseFileService;

    @PostMapping("/create")
    public Result<?> create(@Valid @RequestBody CourseDTO courseDTO, HttpServletRequest request) {
        Long teacherId = (Long) request.getAttribute("userId");
        return courseService.createCourse(courseDTO, teacherId);
    }

    @PutMapping("/update/{courseId}")
    public Result<?> update(@PathVariable Long courseId, @Valid @RequestBody CourseDTO courseDTO) {
        return courseService.updateCourse(courseId, courseDTO);
    }

    @DeleteMapping("/{courseId}")
    public Result<?> delete(@PathVariable Long courseId) {
        return courseService.deleteCourse(courseId);
    }

    @GetMapping("/{courseId}")
    public Result<?> detail(@PathVariable Long courseId) {
        return courseService.getCourseDetail(courseId);
    }

    @GetMapping("/list")
    public Result<?> list(HttpServletRequest request) {
        Long teacherId = (Long) request.getAttribute("userId");
        return courseService.listCourses(teacherId);
    }

    /** 管理员查看所有课程（不按教师过滤） */
    @GetMapping("/listAll")
    public Result<?> listAll() {
        return courseService.listAllCourses();
    }

    // ========== 教师分配学生 ==========

    /** 分配学生到课程 */
    @PostMapping("/{courseId}/assignStudents")
    public Result<?> assignStudents(@PathVariable Long courseId, @RequestBody List<Long> studentIds) {
        return courseService.assignStudents(courseId, studentIds);
    }

    /** 查看课程已分配的学生 */
    @GetMapping("/{courseId}/students")
    public Result<?> getCourseStudents(@PathVariable Long courseId) {
        return courseService.getCourseStudents(courseId);
    }

    /** 移除课程中的学生 */
    @DeleteMapping("/{courseId}/student/{studentId}")
    public Result<?> removeStudent(@PathVariable Long courseId, @PathVariable Long studentId) {
        return courseService.removeStudent(courseId, studentId);
    }

    /** 查询所有学生（供教师分配用） */
    @GetMapping("/students/all")
    public Result<?> listAllStudents() {
        return courseService.listAllStudents();
    }

    // ========== 课程资源管理 ==========

    /** 教师上传课程资源文件 */
    @PostMapping("/{courseId}/file/upload")
    public Result<?> uploadFile(@PathVariable Long courseId,
                                @RequestParam("file") MultipartFile file,
                                HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        return courseFileService.uploadFile(courseId, userId, role, file);
    }

    /** 获取课程资源文件列表（教师和学生均可查看） */
    @GetMapping("/{courseId}/files")
    public Result<?> getFiles(@PathVariable Long courseId) {
        return courseFileService.getFiles(courseId);
    }

    /** 删除课程资源文件 */
    @DeleteMapping("/file/{fileId}")
    public Result<?> deleteFile(@PathVariable Long fileId, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        return courseFileService.deleteFile(fileId, userId, role);
    }

    // ========== 学生端 ==========

    /** 学生查看自己被分配的课程 */
    @GetMapping("/student/list")
    public Result<?> listStudentCourses(HttpServletRequest request) {
        Long studentId = (Long) request.getAttribute("userId");
        return courseService.listStudentCourses(studentId);
    }
}
