import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/provider/data_provider.dart';
import 'package:bendy_jizhang/util/amount_util.dart';
import 'package:bendy_jizhang/util/date_util.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateUtil.today();
    final monthStart = DateUtil.monthStart();
    final weekStart = DateUtil.weekStart();
    final yearStart = DateUtil.yearStart();

    final todayTx = ref.watch(transactionsByDateRangeProvider((today, today)));
    final weekTx = ref.watch(transactionsByDateRangeProvider((weekStart, today)));
    final monthTx = ref.watch(transactionsByDateRangeProvider((monthStart, today)));
    final yearTx = ref.watch(transactionsByDateRangeProvider((yearStart, today)));

    double todayExpense = 0, todayIncome = 0;
    double weekExpense = 0, weekIncome = 0;
    double monthExpense = 0, monthIncome = 0;
    double yearExpense = 0, yearIncome = 0;

    todayTx.whenData((list) {
      for (final tx in list) {
        if (tx.type == TransactionType.expense) {
          todayExpense += tx.sourceAmount;
        } else {
          todayIncome += tx.sourceAmount;
        }
      }
    });
    weekTx.whenData((list) {
      for (final tx in list) {
        if (tx.type == TransactionType.expense) {
          weekExpense += tx.sourceAmount;
        } else {
          weekIncome += tx.sourceAmount;
        }
      }
    });
    monthTx.whenData((list) {
      for (final tx in list) {
        if (tx.type == TransactionType.expense) {
          monthExpense += tx.sourceAmount;
        } else {
          monthIncome += tx.sourceAmount;
        }
      }
    });
    yearTx.whenData((list) {
      for (final tx in list) {
        if (tx.type == TransactionType.expense) {
          yearExpense += tx.sourceAmount;
        } else {
          yearIncome += tx.sourceAmount;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Bendy 记账')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SummaryCard(title: '今日', expense: todayExpense, income: todayIncome),
          const SizedBox(height: 8),
          _SummaryCard(title: '本周', expense: weekExpense, income: weekIncome),
          const SizedBox(height: 8),
          _SummaryCard(title: '本月', expense: monthExpense, income: monthIncome),
          const SizedBox(height: 8),
          _SummaryCard(title: '本年', expense: yearExpense, income: yearIncome),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '本月净收入：${AmountUtil.format(monthIncome - monthExpense)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('最近交易', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          monthTx.when(
            data: (list) {
              final recent = list.take(10).toList();
              if (recent.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('暂无交易记录')),
                  ),
                );
              }
              return Column(
                children: recent.map((tx) => _TransactionTile(tx: tx)).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('加载失败: $e'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double expense;
  final double income;
  const _SummaryCard({required this.title, required this.expense, required this.income});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            Text('支出 ${AmountUtil.format(expense)}',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(width: 16),
            Text('收入 ${AmountUtil.format(income)}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final BendyTransaction tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isExpense = tx.type == TransactionType.expense;
    final prefix = isExpense ? '-' : '+';
    return ListTile(
      leading: const Icon(Icons.receipt_long),
      title: Text(tx.comment ?? tx.type.name),
      subtitle: Text(tx.date),
      trailing: Text(
        '$prefix${AmountUtil.format(tx.sourceAmount, currency: '')}',
        style: TextStyle(
          color: isExpense ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
