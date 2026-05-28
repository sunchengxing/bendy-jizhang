import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/util/amount_util.dart';
import 'package:bendy_jizhang/util/color_util.dart';
import 'package:bendy_jizhang/provider/data_provider.dart';
import 'package:bendy_jizhang/provider/repository_provider.dart';
import 'package:go_router/go_router.dart';

class AccountListScreen extends ConsumerWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetAsync = ref.watch(accountsByTypeProvider(AccountType.asset));
    final liabilityAsync =
        ref.watch(accountsByTypeProvider(AccountType.liability));
    final allAsync = ref.watch(allAccountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('账户'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/accounts/add'),
          ),
        ],
      ),
      body: allAsync.when(
        data: (all) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _AccountGroup(
                title: '资产账户',
                accounts: assetAsync.asData?.value ?? [],
                onEdit: (id) => context.go('/accounts/$id'),
                onDelete: (account) => _confirmDelete(context, ref, account),
              ),
              const SizedBox(height: 16),
              _AccountGroup(
                title: '负债账户',
                accounts: liabilityAsync.asData?.value ?? [],
                onEdit: (id) => context.go('/accounts/$id'),
                onDelete: (account) => _confirmDelete(context, ref, account),
              ),
              const SizedBox(height: 16),
              _NetWorthCard(
                assetTotal: (assetAsync.asData?.value ?? [])
                    .fold(0.0, (s, a) => s + a.balance),
                liabilityTotal: (liabilityAsync.asData?.value ?? [])
                    .fold(0.0, (s, a) => s + a.balance),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Account account) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('删除账户「${account.name}」？相关交易不会删除。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              ref.read(accountRepositoryProvider).delete(account);
              Navigator.pop(ctx);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

class _AccountGroup extends StatelessWidget {
  final String title;
  final List<Account> accounts;
  final void Function(int id) onEdit;
  final void Function(Account account) onDelete;

  const _AccountGroup({
    required this.title,
    required this.accounts,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Card(
          child: Column(
            children: accounts.map((acc) => ListTile(
              leading: CircleAvatar(
                backgroundColor: ColorUtil.fromHex(acc.color),
                child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
              ),
              title: Text(acc.name),
              subtitle: Text(acc.currency),
              trailing: Text(
                AmountUtil.format(acc.balance),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => onEdit(acc.id),
              onLongPress: () => onDelete(acc),
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class _NetWorthCard extends StatelessWidget {
  final double assetTotal;
  final double liabilityTotal;
  const _NetWorthCard({required this.assetTotal, required this.liabilityTotal});

  @override
  Widget build(BuildContext context) {
    final net = assetTotal - liabilityTotal;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('总资产', style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                Text(AmountUtil.format(assetTotal)),
              ],
            ),
            Row(
              children: [
                Text('总负债', style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                Text(AmountUtil.format(liabilityTotal),
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Text('净资产', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(AmountUtil.format(net),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
