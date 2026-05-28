import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/util/amount_util.dart';
import 'package:bendy_jizhang/util/date_util.dart';
import 'package:bendy_jizhang/util/color_util.dart';
import 'package:bendy_jizhang/provider/data_provider.dart';
import 'package:bendy_jizhang/provider/repository_provider.dart';
import 'package:go_router/go_router.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState
    extends ConsumerState<TransactionListScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final yearStart = '${now.year.toString().padLeft(4, '0')}-01-01';
    final yearEnd = '${now.year.toString().padLeft(4, '0')}-12-31';

    final txAsync =
        ref.watch(transactionsByDateRangeProvider((yearStart, yearEnd)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('交易列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/transactions/add'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索备注...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
        ),
      ),
      body: txAsync.when(
        data: (transactions) {
          var list = transactions;
          if (_searchQuery.isNotEmpty) {
            list = list
                .where((tx) =>
                    (tx.comment ?? '').contains(_searchQuery))
                .toList();
          }
          if (list.isEmpty) {
            return const Center(child: Text('暂无交易记录'));
          }
          final grouped = _groupByMonth(list);
          return ListView.builder(
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final month = grouped.keys.elementAt(index);
              final items = grouped[month]!;
              final monthTotal = items.fold<double>(0, (sum, tx) =>
                  tx.type == TransactionType.expense
                      ? sum - tx.sourceAmount
                      : sum + tx.sourceAmount);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      children: [
                        Text(DateUtil.displayMonth(month),
                            style: Theme.of(context).textTheme.titleSmall),
                        const Spacer(),
                        Text(AmountUtil.formatWithSign(monthTotal),
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  ...items.map((tx) => Dismissible(
                        key: ValueKey(tx.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Theme.of(context).colorScheme.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) => showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('确认删除'),
                            content: const Text('删除后无法恢复，确认删除此交易？'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('取消')),
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('删除')),
                            ],
                          ),
                        ),
                        onDismissed: (_) async {
                          await ref
                              .read(transactionRepositoryProvider)
                              .delete(tx);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                ColorUtil.fromHex('#607D8B'),
                            radius: 18,
                            child: Icon(
                                _typeIcon(tx.type),
                                color: Colors.white,
                                size: 18),
                          ),
                          title: Text(tx.comment?.isNotEmpty == true
                              ? tx.comment!
                              : tx.type.name),
                          subtitle: Text(tx.date),
                          trailing: Text(
                            AmountUtil.formatWithSign(
                              tx.type == TransactionType.expense
                                  ? -tx.sourceAmount
                                  : tx.sourceAmount,
                            ),
                            style: TextStyle(
                              color: tx.type == TransactionType.expense
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onTap: () =>
                              context.go('/transactions/${tx.id}'),
                        ),
                      )),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
      ),
    );
  }

  Map<String, List<BendyTransaction>> _groupByMonth(
      List<BendyTransaction> list) {
    final map = <String, List<BendyTransaction>>{};
    for (final tx in list) {
      final month = tx.date.substring(0, 7);
      map.putIfAbsent(month, () => []).add(tx);
    }
    return map;
  }

  IconData _typeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return Icons.remove_circle_outline;
      case TransactionType.income:
        return Icons.add_circle_outline;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }
}
