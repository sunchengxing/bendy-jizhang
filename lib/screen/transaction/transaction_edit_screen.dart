import 'package:flutter/material.dart';

class TransactionEditScreen extends StatelessWidget {
  final int? id;
  const TransactionEditScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(id != null ? '编辑交易' : '新建交易')),
      body: const Center(child: Text('TransactionEditScreen - Phase 2')),
    );
  }
}
