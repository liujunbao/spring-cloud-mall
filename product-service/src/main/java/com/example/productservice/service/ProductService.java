package com.example.productservice.service;

import com.example.productservice.dto.ProductDTO;
import com.example.productservice.dto.ProductRequest;
import org.springframework.data.domain.Page;

import java.util.List;

public interface ProductService {
    ProductDTO createProduct(ProductRequest request);
    ProductDTO updateProduct(Long id, ProductRequest request);
    void deleteProduct(Long id);
    ProductDTO getProductById(Long id);
    Page<ProductDTO> getAllProducts(int page, int size, String keyword, Long categoryId);
    List<ProductDTO> getProductsByCategory(Long categoryId);
    List<ProductDTO> searchProducts(String keyword);
    List<ProductDTO> getProductsByPriceRange(Double minPrice, Double maxPrice);
    void updateStock(Long id, Integer quantity);
    List<ProductDTO> getLowStockProducts(Integer threshold);
} 