package com.software.testing.coursemodule.dto;

import lombok.Data;
import javax.validation.constraints.NotBlank;

@Data
public class CourseDTO {
    @NotBlank(message = "课程名称不能为空")
    private String courseName;
    private String description;
}
