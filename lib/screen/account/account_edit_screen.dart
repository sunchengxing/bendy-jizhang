import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/widget/color_picker_sheet.dart' show showColorPickerSheet;
import 'package:bendy_jizhang/widget/icon_picker_sheet.dart' show showIconPickerSheet, IconNames;
import 'package:bendy_jizhang/provider/repository_provider.dart';
import 'package:go_router/go_router.dart';

class AccountEditScreen extends ConsumerStatefulWidget {
  final int? id;
  const AccountEditScreen({super.key, this.id});

  @override
  ConsumerState<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends ConsumerState<AccountEditScreen> {
  final _nameController = TextEditingController();
  AccountType _type = AccountType.asset;
  String _icon = 'account_balance';
  String _color = '#2196F3';
  double _initialBalance = 0;
  bool _isCounting = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) _loadAccount();
    else _loading = false;
  }

  Future<void> _loadAccount() async {
    final acc = await ref.read(accountRepositoryProvider).watchById(widget.id!).first;
    if (acc != null && mounted) {
      setState(() {
        _nameController.text = acc.name;
        _type = acc.type;
        _icon = acc.icon;
        _color = acc.color;
        _initialBalance = acc.initialBalance;
        _isCounting = acc.isCounting;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入账户名称')));
      return;
    }
    await ref.read(accountRepositoryProvider).save(AccountsCompanion.insert(
      type: _type,
      name: name,
      icon: _icon,
      color: _color,
      currency: 'CNY',
      initialBalance: Value(_initialBalance),
      balance: Value(_initialBalance),
      isCounting: Value(_isCounting),
    ));
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? '编辑账户' : '新建账户'),
        actions: [TextButton(onPressed: _save, child: const Text('保存'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<AccountType>(
            segments: const [
              ButtonSegment(value: AccountType.asset, label: Text('资产')),
              ButtonSegment(value: AccountType.liability, label: Text('负债')),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '账户名称', border: OutlineInputBorder()),
            maxLength: 50,
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('图标'),
            trailing: Icon(IconNames[_icon] ?? Icons.account_balance),
            onTap: () async {
              final icon = await showIconPickerSheet(context, selected: _icon);
              if (icon != null) setState(() => _icon = icon);
            },
          ),
          ListTile(
            title: const Text('颜色'),
            trailing: CircleAvatar(backgroundColor: _parseColor(_color), radius: 14),
            onTap: () async {
              final c = await showColorPickerSheet(context, selected: _color);
              if (c != null) setState(() => _color = c);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('计入总资产'),
            value: _isCounting,
            onChanged: (v) => setState(() => _isCounting = v),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('保存')),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
