package com.example.productservice.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CategoryRequest {
    @NotBlank(message = "分类名称不能为空")
    private String name;

    private String description;

    private Long parentId;

    private Integer level;

    private Integer sortOrder;
} 