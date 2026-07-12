package com.software.testing.coursemodule.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.software.testing.common.Result;
import com.software.testing.coursemodule.entity.Course;
import com.software.testing.coursemodule.entity.CourseFile;
import com.software.testing.coursemodule.mapper.CourseFileMapper;
import com.software.testing.coursemodule.mapper.CourseMapper;
import com.software.testing.coursemodule.service.CourseFileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Service
public class CourseFileServiceImpl implements CourseFileService {

    private static final Logger log = LoggerFactory.getLogger(CourseFileServiceImpl.class);

    @Value("${file.upload-dir:./uploads}")
    private String uploadDir;

    @Autowired
    private CourseFileMapper courseFileMapper;

    @Autowired
    private CourseMapper courseMapper;

    @Override
    public Result<?> uploadFile(Long courseId, Long userId, String role, MultipartFile file) {
        log.info("[上传课程资源] courseId={}, userId={}, role={}, fileName={}", courseId, userId, role, file.getOriginalFilename());
        // 校验课程存在
        Course course = courseMapper.selectById(courseId);
        if (course == null) {
            return Result.error("课程不存在");
        }
        // ADMIN 或课程所属教师均可上传
        if (!"ADMIN".equals(role) && !course.getTeacherId().equals(userId)) {
            return Result.error("无权上传资源到该课程");
        }
        try {
            // 使用绝对路径确保文件写入正确位置（避免Tomcat临时目录问题）
            File baseDir = new File(uploadDir);
            if (!baseDir.isAbsolute()) {
                baseDir = new File(System.getProperty("user.dir"), uploadDir);
            }
            String dateDir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            Path dirPath = Paths.get(baseDir.getAbsolutePath(), "course_files", dateDir);
            Files.createDirectories(dirPath);

            // 生成唯一文件名
            String originalName = file.getOriginalFilename();
            String ext = "";
            if (originalName != null && originalName.contains(".")) {
                ext = originalName.substring(originalName.lastIndexOf("."));
            }
            String storedName = UUID.randomUUID().toString() + ext;
            Path filePath = dirPath.resolve(storedName);

            // 保存文件
            file.transferTo(filePath.toFile());
            log.info("[文件已保存] path={}", filePath.toAbsolutePath());

            // 保存数据库记录（存绝对路径，方便后续删除查找）
            CourseFile courseFile = new CourseFile();
            courseFile.setCourseId(courseId);
            courseFile.setFileName(originalName);
            courseFile.setFilePath(filePath.toAbsolutePath().toString());
            courseFile.setFileUrl("/uploads/course_files/" + dateDir + "/" + storedName);
            courseFile.setFileSize(file.getSize());
            courseFile.setFileType(ext.replace(".", "").toLowerCase());
            courseFileMapper.insert(courseFile);

            log.info("[上传课程资源成功] id={}, fileName={}", courseFile.getId(), originalName);
            return Result.success("上传成功", courseFile);
        } catch (IOException e) {
            log.error("[上传课程资源失败] {}", e.getMessage(), e);
            return Result.error("文件上传失败: " + e.getMessage());
        }
    }

    @Override
    public Result<?> getFiles(Long courseId) {
        log.info("[查询课程资源] courseId={}", courseId);
        List<CourseFile> files = courseFileMapper.selectList(
                new LambdaQueryWrapper<CourseFile>()
                        .eq(CourseFile::getCourseId, courseId)
                        .orderByDesc(CourseFile::getCreateTime));
        return Result.success(files);
    }

    @Override
    public Result<?> deleteFile(Long fileId, Long userId, String role) {
        log.info("[删除课程资源] fileId={}, userId={}, role={}", fileId, userId, role);
        CourseFile courseFile = courseFileMapper.selectById(fileId);
        if (courseFile == null) {
            return Result.error("文件不存在");
        }
        // ADMIN 或课程所属教师均可删除
        Course course = courseMapper.selectById(courseFile.getCourseId());
        if (course != null && !"ADMIN".equals(role) && !course.getTeacherId().equals(userId)) {
            return Result.error("无权删除该资源");
        }
        // 删除物理文件
        try {
            Path filePath = Paths.get(courseFile.getFilePath());
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            log.warn("[删除物理文件失败] path={}, msg={}", courseFile.getFilePath(), e.getMessage());
        }
        // 删除数据库记录
        courseFileMapper.deleteById(fileId);
        log.info("[删除课程资源成功] fileId={}", fileId);
        return Result.success("删除成功", null);
    }
}
