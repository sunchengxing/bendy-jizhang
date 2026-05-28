import 'package:drift/drift.dart';
import 'package:bendy_jizhang/model/enums.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<CategoryType>()();
  IntColumn get parentId => integer().nullable().references(Categories, #id)();
  TextColumn get name => text().withLength(min: 1, max: 30)();
  TextColumn get icon => text().withLength(min: 1, max: 50)();
  TextColumn get color => text().withLength(min: 7, max: 7)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
}
