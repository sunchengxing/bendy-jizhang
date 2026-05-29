import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/navigation/app_router.dart';
import 'package:bendy_jizhang/provider/data_init_provider.dart';
import 'package:bendy_jizhang/provider/settings_provider.dart';

class BendyApp extends ConsumerWidget {
  const BendyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initAsync = ref.watch(dataInitProvider);
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Bendy 记账',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: _parseColor(settings.themeColor),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: _parseColor(settings.themeColor),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: settings.themeMode,
      routerConfig: router,
      builder: (context, child) {
        return initAsync.when(
          loading: () => const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          ),
          error: (e, _) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('初始化失败', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('$e', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          data: (_) => child!,
        );
      },
    );
  }

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
