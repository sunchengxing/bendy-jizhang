import 'package:drift/drift.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/database/tables/categories.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  Stream<List<Category>> watchByType(CategoryType type) => (select(categories)
        ..where((t) => t.type.equalsValue(type))
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .watch();

  Stream<List<Category>> watchAll() =>
      (select(categories)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Stream<Category?> watchById(int id) =>
      (select(categories)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future insertOrUpdate(CategoriesCompanion entry) =>
      into(categories).insertOnConflictUpdate(entry);

  Future deleteEntry(Category entry) => delete(categories).delete(entry);
}
