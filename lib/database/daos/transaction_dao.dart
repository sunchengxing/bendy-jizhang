import 'package:drift/drift.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/database/tables/transactions.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Stream<List<BendyTransaction>> watchByDateRange(String start, String end) =>
      (select(transactions)
            ..where((t) => t.date.isBetweenValues(start, end))
            ..orderBy([
              (t) => OrderingTerm.desc(t.date),
              (t) => OrderingTerm.desc(t.time),
            ]))
          .watch();

  Stream<BendyTransaction?> watchById(int id) =>
      (select(transactions)..where((t) => t.id.equals(id)))
          .watchSingleOrNull();

  Stream<List<BendyTransaction>> watchByCategory(int catId) =>
      (select(transactions)..where((t) => t.categoryId.equals(catId)))
          .watch();

  Stream<List<BendyTransaction>> watchByAccount(int accId) => (select(transactions)
        ..where(
            (t) => t.sourceAccountId.equals(accId) | t.destinationAccountId.equals(accId)))
      .watch();

  Future insertOrUpdate(TransactionsCompanion entry) =>
      into(transactions).insertOnConflictUpdate(entry);

  Future deleteEntry(BendyTransaction entry) => delete(transactions).delete(entry);
}
