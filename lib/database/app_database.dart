import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/database/tables/accounts.dart';
import 'package:bendy_jizhang/database/tables/transactions.dart';
import 'package:bendy_jizhang/database/tables/categories.dart';
import 'package:bendy_jizhang/database/daos/account_dao.dart';
import 'package:bendy_jizhang/database/daos/transaction_dao.dart';
import 'package:bendy_jizhang/database/daos/category_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Accounts, Transactions, Categories], daos: [AccountDao, TransactionDao, CategoryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbDir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbDir.path, 'bendy_jizhang.sqlite'));
      // 确保 sqlite3 native 库可用
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  int get schemaVersion => 1;

  late final accountDao = AccountDao(this);
  late final transactionDao = TransactionDao(this);
  late final categoryDao = CategoryDao(this);
}
