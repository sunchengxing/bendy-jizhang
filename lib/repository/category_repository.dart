import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/database/daos/category_dao.dart';
import 'package:bendy_jizhang/model/enums.dart';

class CategoryRepository {
  final CategoryDao _dao;
  CategoryRepository(this._dao);

  Stream<List<Category>> watchByType(CategoryType type) => _dao.watchByType(type);
  Stream<List<Category>> watchAll() => _dao.watchAll();
  Stream<Category?> watchById(int id) => _dao.watchById(id);
  Future save(CategoriesCompanion entry) => _dao.insertOrUpdate(entry);
  Future delete(Category entry) => _dao.deleteEntry(entry);
}
