import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/database/daos/transaction_dao.dart';

class TransactionRepository {
  final TransactionDao _dao;
  TransactionRepository(this._dao);

  Stream<List<BendyTransaction>> watchByDateRange(String start, String end) =>
      _dao.watchByDateRange(start, end);
  Stream<BendyTransaction?> watchById(int id) => _dao.watchById(id);
  Future save(TransactionsCompanion entry) => _dao.insertOrUpdate(entry);
  Future delete(BendyTransaction entry) => _dao.deleteEntry(entry);
}
