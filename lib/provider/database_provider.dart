import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/database/daos/account_dao.dart';
import 'package:bendy_jizhang/database/daos/transaction_dao.dart';
import 'package:bendy_jizhang/database/daos/category_dao.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final accountDaoProvider = Provider<AccountDao>(
    (ref) => ref.watch(appDatabaseProvider).accountDao);

final transactionDaoProvider = Provider<TransactionDao>(
    (ref) => ref.watch(appDatabaseProvider).transactionDao);

final categoryDaoProvider = Provider<CategoryDao>(
    (ref) => ref.watch(appDatabaseProvider).categoryDao);
