package com.software.testing.coursemodule.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("t_course_student")
public class CourseStudent {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long courseId;
    private Long studentId;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
