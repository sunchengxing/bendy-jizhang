import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/provider/repository_provider.dart';

final allAccountsProvider = StreamProvider<List<Account>>(
    (ref) => ref.watch(accountRepositoryProvider).watchAll());

final allCategoriesProvider = StreamProvider<List<Category>>(
    (ref) => ref.watch(categoryRepositoryProvider).watchAll());

final accountsByTypeProvider =
    StreamProvider.family<List<Account>, AccountType>((ref, type) =>
        ref.watch(accountRepositoryProvider).watchByType(type));

final categoriesByTypeProvider =
    StreamProvider.family<List<Category>, CategoryType>((ref, type) =>
        ref.watch(categoryRepositoryProvider).watchByType(type));

final transactionsByDateRangeProvider =
    StreamProvider.family<List<BendyTransaction>, (String, String)>(
        (ref, range) => ref
            .watch(transactionRepositoryProvider)
            .watchByDateRange(range.$1, range.$2));
