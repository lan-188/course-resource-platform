package com.software.testing.coursemodule.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("t_course_file")
public class CourseFile {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long courseId;
    private String fileName;       // 原始文件名
    private String filePath;       // 存储路径
    private String fileUrl;        // 访问URL
    private Long fileSize;         // 文件大小(字节)
    private String fileType;       // 文件类型
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
