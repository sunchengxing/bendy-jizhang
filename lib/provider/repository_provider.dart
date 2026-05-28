import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/repository/account_repository.dart';
import 'package:bendy_jizhang/repository/transaction_repository.dart';
import 'package:bendy_jizhang/repository/category_repository.dart';
import 'package:bendy_jizhang/provider/database_provider.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
    (ref) => AccountRepository(ref.watch(accountDaoProvider)));

final transactionRepositoryProvider = Provider<TransactionRepository>(
    (ref) => TransactionRepository(ref.watch(transactionDaoProvider)));

final categoryRepositoryProvider = Provider<CategoryRepository>(
    (ref) => CategoryRepository(ref.watch(categoryDaoProvider)));
