package com.example.productservice.dto;

import lombok.Data;

@Data
public class CategoryDTO {
    private Long id;
    private String name;
    private String description;
    private Long parentId;
    private Integer level;
    private Integer sortOrder;
} 