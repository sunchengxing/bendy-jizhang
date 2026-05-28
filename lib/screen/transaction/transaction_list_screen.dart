import 'package:flutter/material.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('交易列表')),
      body: const Center(child: Text('TransactionListScreen - Phase 2')),
    );
  }
}
