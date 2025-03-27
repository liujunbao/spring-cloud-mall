import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品分类'),
      ),
      body: const Center(
        child: Text('分类页面'),
      ),
    );
  }
}
