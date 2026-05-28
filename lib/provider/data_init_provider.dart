import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/provider/database_provider.dart';
import 'package:drift/drift.dart';

final dataInitProvider = Provider<Future<void>>((ref) async {
  final db = ref.read(appDatabaseProvider);
  final existing = await (db.select(db.categories)).get();
  if (existing.isEmpty) {
    await _insertPresetCategories(db);
    await _insertPresetAccounts(db);
  }
});

Future<void> _insertPresetCategories(AppDatabase db) async {
  final expenseCategories = [
    (name: '餐饮', icon: 'restaurant', color: '#FF5722', sort: 0),
    (name: '交通', icon: 'directions_car', color: '#2196F3', sort: 1),
    (name: '购物', icon: 'shopping_cart', color: '#E91E63', sort: 2),
    (name: '居住', icon: 'home', color: '#795548', sort: 3),
    (name: '通讯', icon: 'phone_android', color: '#00BCD4', sort: 4),
    (name: '娱乐', icon: 'sports_esports', color: '#9C27B0', sort: 5),
    (name: '医疗', icon: 'local_hospital', color: '#F44336', sort: 6),
    (name: '教育', icon: 'school', color: '#4CAF50', sort: 7),
    (name: '其他支出', icon: 'inventory_2', color: '#607D8B', sort: 8),
  ];

  final incomeCategories = [
    (name: '工资', icon: 'payments', color: '#4CAF50', sort: 0),
    (name: '奖金', icon: 'card_giftcard', color: '#FF9800', sort: 1),
    (name: '理财', icon: 'trending_up', color: '#2196F3', sort: 2),
    (name: '兼职', icon: 'work', color: '#795548', sort: 3),
    (name: '其他收入', icon: 'star', color: '#FFC107', sort: 4),
  ];

  for (final c in expenseCategories) {
    await db.categoryDao.insertOrUpdate(CategoriesCompanion.insert(
      type: CategoryType.expense,
      name: c.name,
      icon: c.icon,
      color: c.color,
      sortOrder: Value(c.sort),
    ));
  }

  for (final c in incomeCategories) {
    await db.categoryDao.insertOrUpdate(CategoriesCompanion.insert(
      type: CategoryType.income,
      name: c.name,
      icon: c.icon,
      color: c.color,
      sortOrder: Value(c.sort),
    ));
  }
}

Future<void> _insertPresetAccounts(AppDatabase db) async {
  final accounts = [
    (name: '现金', type: AccountType.asset, icon: 'money', color: '#4CAF50', sort: 0),
    (name: '储蓄卡', type: AccountType.asset, icon: 'account_balance', color: '#2196F3', sort: 1),
    (name: '信用卡', type: AccountType.liability, icon: 'credit_card', color: '#F44336', sort: 2),
  ];

  for (final a in accounts) {
    await db.accountDao.insertOrUpdate(AccountsCompanion.insert(
      type: a.type,
      name: a.name,
      icon: a.icon,
      color: a.color,
      currency: 'CNY',
      sortOrder: Value(a.sort),
    ));
  }
}
