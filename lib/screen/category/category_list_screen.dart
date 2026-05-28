import 'package:flutter/material.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('分类管理')),
      body: const Center(child: Text('CategoryListScreen - Phase 3')),
    );
  }
}
