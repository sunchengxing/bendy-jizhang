import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('统计分析')),
      body: const Center(child: Text('StatisticsScreen - Phase 4')),
    );
  }
}
