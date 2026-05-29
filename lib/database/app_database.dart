import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

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
  AppDatabase() : super(driftDatabase(
      name: 'bendy_jizhang',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    ));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  late final accountDao = AccountDao(this);
  late final transactionDao = TransactionDao(this);
  late final categoryDao = CategoryDao(this);
}
