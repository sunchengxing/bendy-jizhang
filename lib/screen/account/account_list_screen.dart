import 'package:flutter/material.dart';

class AccountListScreen extends StatelessWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('账户')),
      body: const Center(child: Text('AccountListScreen - Phase 3')),
    );
  }
}
