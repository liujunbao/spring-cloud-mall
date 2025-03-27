import 'package:dio/dio.dart';
import '../models/product.dart';

class ProductService {
  final Dio _dio;

  ProductService(this._dio) {
    _dio.options.baseUrl = 'http://localhost:9000/api';
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<List<Product>> getProducts({
    int page = 1,
    int size = 10,
    String? keyword,
    int? categoryId,
  }) async {
    try {
      print('Fetching products with page: $page, size: $size');
      final response = await _dio.get('/products', queryParameters: {
        'page': page,
        'size': size,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        if (categoryId != null) 'categoryId': categoryId,
      });

      print('Response data: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['code'].toString() == '200') {
          final data = responseData['data'] as Map<String, dynamic>;
          final content = data['content'] as List;
          return content
              .map((json) => Product.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(responseData['message'] ?? '获取商品列表失败');
        }
      } else {
        throw Exception('返回数据格式错误');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('获取商品列表失败: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['code'].toString() == '200') {
          return Product.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          throw Exception(responseData['message'] ?? '获取商品详情失败');
        }
      } else {
        throw Exception('返回数据格式错误');
      }
    } catch (e) {
      throw Exception('获取商品详情失败: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/products', queryParameters: {
        'categoryId': categoryId,
        'page': 0,
        'size': 20,
      });

      if (response.data['code'] == 200) {
        final List<dynamic> content = response.data['data']['content'] as List;
        return content.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '获取分类商品失败');
      }
    } catch (e) {
      throw Exception('获取分类商品失败: $e');
    }
  }

  Future<List<Product>> searchProducts(String keyword) async {
    try {
      final response = await _dio.get('/products', queryParameters: {
        'keyword': keyword,
        'page': 0,
        'size': 20,
      });

      if (response.data['code'] == 200) {
        final List<dynamic> content = response.data['data']['content'] as List;
        return content.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '搜索商品失败');
      }
    } catch (e) {
      throw Exception('搜索商品失败: $e');
    }
  }
}
