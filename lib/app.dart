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

    return initAsync.when(
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (e, st) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
        home: _ErrorScreen(error: e, stackTrace: st),
      ),
      data: (_) => _AppContent(settings: settings),
    );
  }

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}

class _AppContent extends ConsumerWidget {
  final SettingsState settings;
  const _AppContent({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final color = _parseColor(settings.themeColor);

    return MaterialApp.router(
      title: 'Bendy 记账',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: color, useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(colorSchemeSeed: color, useMaterial3: true, brightness: Brightness.dark),
      themeMode: settings.themeMode,
      routerConfig: router,
    );
  }

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}

class _ErrorScreen extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  const _ErrorScreen({required this.error, this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text('$error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
