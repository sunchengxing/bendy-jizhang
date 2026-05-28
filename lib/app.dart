import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/navigation/app_router.dart';
import 'package:bendy_jizhang/provider/data_init_provider.dart';

class BendyApp extends ConsumerWidget {
  const BendyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dataInitProvider);

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Bendy 记账',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6200EE),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6200EE),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
