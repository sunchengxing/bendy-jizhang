import 'package:go_router/go_router.dart';
import 'package:bendy_jizhang/navigation/app_scaffold.dart';
import 'package:bendy_jizhang/screen/home/home_screen.dart';
import 'package:bendy_jizhang/screen/account/account_list_screen.dart';
import 'package:bendy_jizhang/screen/account/account_edit_screen.dart';
import 'package:bendy_jizhang/screen/transaction/transaction_edit_screen.dart';
import 'package:bendy_jizhang/screen/transaction/transaction_list_screen.dart';
import 'package:bendy_jizhang/screen/category/category_list_screen.dart';
import 'package:bendy_jizhang/screen/statistics/statistics_screen.dart';
import 'package:bendy_jizhang/screen/settings/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appRouterProvider = Provider<GoRouter>((ref) => GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppScaffold(child: child),
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
            GoRoute(path: '/accounts', builder: (context, state) => const AccountListScreen()),
            GoRoute(path: '/transactions', builder: (context, state) => const TransactionListScreen()),
            GoRoute(path: '/statistics', builder: (context, state) => const StatisticsScreen()),
            GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
          ],
        ),
        GoRoute(path: '/accounts/add', builder: (context, state) => const AccountEditScreen()),
        GoRoute(
          path: '/accounts/:id',
          builder: (context, state) => AccountEditScreen(id: int.parse(state.pathParameters['id']!)),
        ),
        GoRoute(path: '/transactions/add', builder: (context, state) => const TransactionEditScreen()),
        GoRoute(
          path: '/transactions/:id',
          builder: (context, state) => TransactionEditScreen(id: int.parse(state.pathParameters['id']!)),
        ),
        GoRoute(path: '/categories', builder: (context, state) => const CategoryListScreen()),
      ],
    ));
