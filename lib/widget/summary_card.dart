import 'package:flutter/material.dart';
import 'package:bendy_jizhang/util/amount_util.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double expense;
  final double income;
  const SummaryCard({super.key, required this.title, required this.expense, required this.income});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('支出 ${AmountUtil.format(expense)}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
                const SizedBox(width: 12),
                Text('收入 ${AmountUtil.format(income)}',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
