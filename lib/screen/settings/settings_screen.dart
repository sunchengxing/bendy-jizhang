import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/provider/settings_provider.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/provider/database_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final db = ref.read(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          // Appearance
          _SectionHeader(title: '外观'),
          ListTile(
            title: const Text('主题模式'),
            subtitle: Text(_themeLabel(settings.themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context, ref),
          ),
          // Data
          _SectionHeader(title: '数据'),
          ListTile(
            title: const Text('默认货币'),
            subtitle: Text(settings.currency),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCurrencyPicker(context, ref),
          ),
          ListTile(
            title: const Text('清除所有数据'),
            subtitle: const Text('删除所有交易、账户和分类'),
            trailing: Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            onTap: () => _confirmClearData(context, db),
          ),
          // About
          _SectionHeader(title: '关于'),
          const ListTile(
            title: Text('Bendy 记账'),
            subtitle: Text('v0.6.0'),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system: return '跟随系统';
      case ThemeMode.light: return '浅色';
      case ThemeMode.dark: return '深色';
    }
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('选择主题'),
        children: ThemeMode.values.map((mode) => SimpleDialogOption(
          onPressed: () {
            ref.read(settingsProvider.notifier).setThemeMode(mode);
            Navigator.pop(ctx);
          },
          child: Text(_themeLabel(mode)),
        )).toList(),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    const currencies = ['CNY', 'USD', 'EUR', 'JPY', 'GBP', 'KRW'];
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('选择货币'),
        children: currencies.map((c) => SimpleDialogOption(
          onPressed: () {
            ref.read(settingsProvider.notifier).setCurrency(c);
            Navigator.pop(ctx);
          },
          child: Text(c),
        )).toList(),
      ),
    );
  }

  void _confirmClearData(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ 确认清除'),
        content: const Text('将删除所有交易、账户和分类数据，此操作不可恢复！'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () async {
              await db.delete(db.transactions).go();
              await db.delete(db.accounts).go();
              await db.delete(db.categories).go();
              if (ctx.mounted) Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('数据已清除')));
            },
            child: Text('清除', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
    );
  }
}
