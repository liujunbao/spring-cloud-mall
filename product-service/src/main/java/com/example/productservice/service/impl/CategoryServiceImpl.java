package com.example.productservice.service.impl;

import com.example.productservice.dto.CategoryDTO;
import com.example.productservice.dto.CategoryRequest;
import com.example.productservice.entity.Category;
import com.example.productservice.repository.CategoryRepository;
import com.example.productservice.service.CategoryService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    @Override
    @Transactional
    public CategoryDTO createCategory(CategoryRequest request) {
        Category category = new Category();
        updateCategoryFromRequest(category, request);
        
        // 如果没有提供 level，根据 parentId 设置
        if (category.getLevel() == null) {
            if (category.getParentId() == null) {
                category.setLevel(1);
            } else {
                Category parent = categoryRepository.findById(category.getParentId())
                        .orElseThrow(() -> new EntityNotFoundException("Parent category not found"));
                category.setLevel(parent.getLevel() + 1);
            }
        }
        
        // 如果没有提供 sortOrder，设置为当前最大排序号 + 1
        if (category.getSortOrder() == null) {
            List<Category> siblings = categoryRepository.findByParentIdOrderBySortOrder(category.getParentId());
            int maxSortOrder = siblings.stream()
                    .mapToInt(Category::getSortOrder)
                    .max()
                    .orElse(0);
            category.setSortOrder(maxSortOrder + 1);
        }
        
        return convertToDTO(categoryRepository.save(category));
    }

    @Override
    @Transactional
    public CategoryDTO updateCategory(Long id, CategoryRequest request) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + id));
        updateCategoryFromRequest(category, request);
        return convertToDTO(categoryRepository.save(category));
    }

    @Override
    @Transactional
    public void deleteCategory(Long id) {
        if (!categoryRepository.existsById(id)) {
            throw new EntityNotFoundException("Category not found with id: " + id);
        }
        categoryRepository.deleteById(id);
    }

    @Override
    public CategoryDTO getCategoryById(Long id) {
        return categoryRepository.findById(id)
                .map(this::convertToDTO)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + id));
    }

    @Override
    public List<CategoryDTO> getAllCategories() {
        return categoryRepository.findAll()
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<CategoryDTO> getCategoriesByParentId(Long parentId) {
        return categoryRepository.findByParentIdOrderBySortOrder(parentId)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<CategoryDTO> getCategoriesByLevel(Integer level) {
        return categoryRepository.findByLevel(level)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private void updateCategoryFromRequest(Category category, CategoryRequest request) {
        category.setName(request.getName());
        category.setDescription(request.getDescription());
        category.setParentId(request.getParentId());
        if (request.getLevel() != null) {
            category.setLevel(request.getLevel());
        }
        if (request.getSortOrder() != null) {
            category.setSortOrder(request.getSortOrder());
        }
    }

    private CategoryDTO convertToDTO(Category category) {
        CategoryDTO dto = new CategoryDTO();
        dto.setId(category.getId());
        dto.setName(category.getName());
        dto.setDescription(category.getDescription());
        dto.setParentId(category.getParentId());
        dto.setLevel(category.getLevel());
        dto.setSortOrder(category.getSortOrder());
        return dto;
    }
} 