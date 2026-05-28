import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/database/daos/account_dao.dart';
import 'package:bendy_jizhang/model/enums.dart';

class AccountRepository {
  final AccountDao _dao;
  AccountRepository(this._dao);

  Stream<List<Account>> watchAll() => _dao.watchAll();
  Stream<Account?> watchById(int id) => _dao.watchById(id);
  Stream<List<Account>> watchByType(AccountType type) => _dao.watchByType(type);
  Future save(AccountsCompanion entry) => _dao.insertOrUpdate(entry);
  Future delete(Account entry) => _dao.deleteEntry(entry);
}
