package com.software.testing.coursemodule.service;

import com.software.testing.common.Result;
import org.springframework.web.multipart.MultipartFile;

public interface CourseFileService {
    /** 上传课程资源文件（ADMIN或课程所属教师均可上传） */
    Result<?> uploadFile(Long courseId, Long userId, String role, MultipartFile file);
    /** 获取课程资源文件列表 */
    Result<?> getFiles(Long courseId);
    /** 删除课程资源文件 */
    Result<?> deleteFile(Long fileId, Long userId, String role);
}
