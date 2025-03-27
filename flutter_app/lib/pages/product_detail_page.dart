import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _productService = ProductService(Dio());
  Product? _product;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final product = await _productService.getProductById(widget.productId);
      setState(() {
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品详情'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProduct,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : _product == null
                  ? const Center(child: Text('商品不存在'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_product!.imageUrl != null)
                            Image.network(
                              _product!.imageUrl!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          else
                            Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            _product!.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '¥${_product!.price.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '库存: ${_product!.stock}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '商品描述',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(_product!.description),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: 添加到购物车
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('加入购物车'),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
