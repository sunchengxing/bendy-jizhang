import 'package:drift/drift.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/database/tables/accounts.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(AppDatabase db) : super(db);

  Stream<List<Account>> watchAll() =>
      (select(accounts)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Stream<Account?> watchById(int id) =>
      (select(accounts)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Stream<List<Account>> watchByType(AccountType type) => (select(accounts)
        ..where((t) => t.type.equalsValue(type))
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .watch();

  Future insertOrUpdate(AccountsCompanion entry) =>
      into(accounts).insertOnConflictUpdate(entry);

  Future deleteEntry(Account entry) => delete(accounts).delete(entry);
}
