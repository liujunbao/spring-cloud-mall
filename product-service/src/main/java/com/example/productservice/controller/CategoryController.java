package com.example.productservice.controller;

import com.example.productservice.dto.ApiResponse;
import com.example.productservice.dto.CategoryDTO;
import com.example.productservice.dto.CategoryRequest;
import com.example.productservice.service.CategoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @PostMapping
    public ResponseEntity<ApiResponse<CategoryDTO>> createCategory(@Valid @RequestBody CategoryRequest request) {
        CategoryDTO category = categoryService.createCategory(request);
        return ResponseEntity.ok(ApiResponse.success(category));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryDTO>> updateCategory(
            @PathVariable Long id,
            @Valid @RequestBody CategoryRequest request) {
        CategoryDTO category = categoryService.updateCategory(id, request);
        return ResponseEntity.ok(ApiResponse.success(category));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteCategory(@PathVariable Long id) {
        categoryService.deleteCategory(id);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryDTO>> getCategory(@PathVariable Long id) {
        CategoryDTO category = categoryService.getCategoryById(id);
        return ResponseEntity.ok(ApiResponse.success(category));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<CategoryDTO>>> getAllCategories() {
        List<CategoryDTO> categories = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(categories));
    }

    @GetMapping("/parent/{parentId}")
    public ResponseEntity<ApiResponse<List<CategoryDTO>>> getCategoriesByParentId(@PathVariable Long parentId) {
        List<CategoryDTO> categories = categoryService.getCategoriesByParentId(parentId);
        return ResponseEntity.ok(ApiResponse.success(categories));
    }

    @GetMapping("/level/{level}")
    public ResponseEntity<ApiResponse<List<CategoryDTO>>> getCategoriesByLevel(@PathVariable Integer level) {
        List<CategoryDTO> categories = categoryService.getCategoriesByLevel(level);
        return ResponseEntity.ok(ApiResponse.success(categories));
    }
} 