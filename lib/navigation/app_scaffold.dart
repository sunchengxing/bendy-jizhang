import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/accounts')) return 1;
    if (location.startsWith('/transactions')) return 2;
    if (location.startsWith('/statistics')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/accounts');
      case 2:
        context.go('/transactions/add');
      case 3:
        context.go('/statistics');
      case 4:
        context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 600;
    final currentIndex = _currentIndex(context);

    final destinations = [
      const NavigationDestination(icon: Icon(Icons.home), label: '首页'),
      const NavigationDestination(
          icon: Icon(Icons.account_balance), label: '账户'),
      const NavigationDestination(
          icon: Icon(Icons.add_circle), label: '记账'),
      const NavigationDestination(
          icon: Icon(Icons.bar_chart), label: '统计'),
      const NavigationDestination(icon: Icon(Icons.settings), label: '设置'),
    ];

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (i) => _onNavTap(context, i),
              labelType: width >= 1024
                  ? NavigationRailLabelType.all
                  : NavigationRailLabelType.selected,
              destinations: destinations
                  .map((d) => NavigationRailDestination(
                        icon: d.icon,
                        selectedIcon: d.selectedIcon,
                        label: Text(d.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _onNavTap(context, i),
        destinations: destinations,
      ),
    );
  }
}
