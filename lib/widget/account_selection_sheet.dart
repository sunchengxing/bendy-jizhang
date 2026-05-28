import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/util/color_util.dart';
import 'package:bendy_jizhang/provider/data_provider.dart';

class AccountSelectionSheet extends ConsumerWidget {
  final AccountType? type;
  final int? selectedId;
  const AccountSelectionSheet({super.key, this.type, this.selectedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = type != null
        ? ref.watch(accountsByTypeProvider(type!))
        : ref.watch(allAccountsProvider);

    return accountsAsync.when(
      data: (accounts) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text('选择账户',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final acc = accounts[index];
                  final isSelected = acc.id == selectedId;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ColorUtil.fromHex(acc.color),
                      child: Icon(Icons.account_balance, color: Colors.white, size: 20),
                    ),
                    title: Text(acc.name),
                    subtitle: Text('${acc.currency} ${acc.balance.toStringAsFixed(2)}'),
                    trailing: isSelected
                        ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                        : null,
                    selected: isSelected,
                    onTap: () => Navigator.pop(context, acc),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }

  static Future<Account?> show(BuildContext context, {AccountType? type, int? selectedId}) {
    return showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AccountSelectionSheet(type: type, selectedId: selectedId),
    );
  }
}
