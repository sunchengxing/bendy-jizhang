import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/util/amount_util.dart';
import 'package:bendy_jizhang/util/color_util.dart';
import 'package:bendy_jizhang/util/date_util.dart';
import 'package:bendy_jizhang/widget/number_pad_sheet.dart' show showNumberPad;
import 'package:bendy_jizhang/widget/category_selection_sheet.dart';
import 'package:bendy_jizhang/widget/account_selection_sheet.dart';
import 'package:bendy_jizhang/widget/date_selection_sheet.dart';
import 'package:bendy_jizhang/provider/repository_provider.dart';
import 'package:go_router/go_router.dart';

class TransactionEditScreen extends ConsumerStatefulWidget {
  final int? id;
  const TransactionEditScreen({super.key, this.id});

  @override
  ConsumerState<TransactionEditScreen> createState() =>
      _TransactionEditScreenState();
}

class _TransactionEditScreenState extends ConsumerState<TransactionEditScreen> {
  TransactionType _type = TransactionType.expense;
  double _amount = 0;
  Category? _category;
  Account? _sourceAccount;
  Account? _destinationAccount;
  String _date = '';
  String _time = '';
  final _commentController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _date = DateUtil.today();
    _time = DateUtil.nowTime();
    if (widget.id != null) {
      _loadTransaction();
    } else {
      _loading = false;
    }
  }

  Future<void> _loadTransaction() async {
    final repo = ref.read(transactionRepositoryProvider);
    final tx = await repo.watchById(widget.id!).first;
    if (tx != null && mounted) {
      setState(() {
        _type = tx.type;
        _amount = tx.sourceAmount;
        _date = tx.date;
        _time = tx.time ?? '';
        _commentController.text = tx.comment ?? '';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  CategoryType get _categoryType =>
      _type == TransactionType.expense ? CategoryType.expense : CategoryType.income;

  Future<void> _save() async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入金额')));
      return;
    }
    if (_sourceAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请选择账户')));
      return;
    }
    if (_type != TransactionType.transfer && _category == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请选择分类')));
      return;
    }

    final repo = ref.read(transactionRepositoryProvider);
    final companion = TransactionsCompanion.insert(
      type: _type,
      sourceAccountId: _sourceAccount!.id,
      destinationAccountId: _type == TransactionType.transfer
          ? Value(_destinationAccount?.id)
          : const Value.absent(),
      sourceAmount: _amount,
      destinationAmount: _type == TransactionType.transfer
          ? Value(_amount)
          : const Value.absent(),
      categoryId: Value(_category?.id),
      comment: Value(_commentController.text.isEmpty ? null : _commentController.text),
      date: _date,
      time: Value(_time.isEmpty ? null : _time),
    );

    await repo.save(companion);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? '编辑交易' : '新建交易'),
        actions: [TextButton(onPressed: _save, child: const Text('保存'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment(value: TransactionType.expense, label: Text('支出')),
              ButtonSegment(value: TransactionType.income, label: Text('收入')),
              ButtonSegment(value: TransactionType.transfer, label: Text('转账')),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() {
              _type = s.first;
              _category = null;
            }),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('金额'),
            subtitle: Text(AmountUtil.format(_amount),
                style: Theme.of(context).textTheme.headlineSmall),
            trailing: const Icon(Icons.edit),
            onTap: () async {
              final val = await showNumberPad(context, initialValue: _amount);
              if (val != null) setState(() => _amount = val);
            },
          ),
          const Divider(),
          if (_type != TransactionType.transfer)
            ListTile(
              title: const Text('分类'),
              subtitle: Text(_category?.name ?? '请选择'),
              trailing: _category != null
                  ? CircleAvatar(backgroundColor: ColorUtil.fromHex(_category!.color), radius: 14)
                  : const Icon(Icons.chevron_right),
              onTap: () async {
                final cat = await CategorySelectionSheet.show(context,
                    type: _categoryType, selectedId: _category?.id);
                if (cat != null) setState(() => _category = cat);
              },
            ),
          ListTile(
            title: Text(_type == TransactionType.transfer ? '转出账户' : '账户'),
            subtitle: Text(_sourceAccount?.name ?? '请选择'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final acc = await AccountSelectionSheet.show(context, selectedId: _sourceAccount?.id);
              if (acc != null) setState(() => _sourceAccount = acc);
            },
          ),
          if (_type == TransactionType.transfer)
            ListTile(
              title: const Text('转入账户'),
              subtitle: Text(_destinationAccount?.name ?? '请选择'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final acc = await AccountSelectionSheet.show(context, selectedId: _destinationAccount?.id);
                if (acc != null) setState(() => _destinationAccount = acc);
              },
            ),
          const Divider(),
          ListTile(
            title: const Text('日期'),
            subtitle: Text(DateUtil.displayDate(_date)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final d = await DateSelectionSheet.show(context, initialDate: _date);
              if (d != null) setState(() => _date = d);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: '备注',
              border: OutlineInputBorder(),
            ),
            maxLength: 200,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
