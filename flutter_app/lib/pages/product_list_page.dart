import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../providers/auth_provider.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _productService = ProductService(Dio());
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts({bool refresh = false}) async {
    if (_isLoading || (!refresh && !_hasMore)) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _currentPage = 1;
        _products = [];
        _hasMore = true;
      }
    });

    try {
      final products = await _productService.getProducts(
        page: _currentPage,
        keyword: _searchController.text,
      );

      setState(() {
        _products.addAll(products);
        _hasMore = products.length == 10;
        _currentPage++;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadProducts();
    }
  }

  Future<void> _onRefresh() async {
    await _loadProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('微商城'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            // 搜索栏
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '搜索商品',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (_) => _loadProducts(refresh: true),
              ),
            ),
            // 商品列表
            Expanded(
              child: _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_error!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _loadProducts(refresh: true),
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    )
                  : _products.isEmpty && !_isLoading
                      ? const Center(child: Text('暂无商品'))
                      : GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemCount: _products.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _products.length) {
                              return _hasMore
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : null;
                            }
                            final product = _products[index];
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(
                                          productId: product.id),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: product.imageUrl != null
                                          ? Image.network(
                                              product.imageUrl!,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '¥${product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
