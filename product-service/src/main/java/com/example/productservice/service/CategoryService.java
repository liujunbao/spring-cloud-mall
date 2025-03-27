package com.example.productservice.service;

import com.example.productservice.dto.CategoryDTO;
import com.example.productservice.dto.CategoryRequest;
import java.util.List;

public interface CategoryService {
    CategoryDTO createCategory(CategoryRequest request);
    CategoryDTO updateCategory(Long id, CategoryRequest request);
    void deleteCategory(Long id);
    CategoryDTO getCategoryById(Long id);
    List<CategoryDTO> getAllCategories();
    List<CategoryDTO> getCategoriesByParentId(Long parentId);
    List<CategoryDTO> getCategoriesByLevel(Integer level);
} 