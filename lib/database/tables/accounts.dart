import 'package:drift/drift.dart';
import 'package:bendy_jizhang/model/enums.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<AccountType>()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get icon => text().withLength(min: 1, max: 50)();
  TextColumn get color => text().withLength(min: 7, max: 7)();
  TextColumn get currency => text().withLength(min: 3, max: 3)();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  RealColumn get initialBalance => real().withDefault(const Constant(0.0))();
  BoolColumn get isCounting => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
