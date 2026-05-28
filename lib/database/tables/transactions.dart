import 'package:drift/drift.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/database/tables/accounts.dart';
import 'package:bendy_jizhang/database/tables/categories.dart';

@DataClassName('BendyTransaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<TransactionType>()();
  @ReferenceName('sourceAccount')
  IntColumn get sourceAccountId => integer().references(Accounts, #id)();
  @ReferenceName('destinationAccount')
  IntColumn get destinationAccountId =>
      integer().nullable().references(Accounts, #id)();
  RealColumn get sourceAmount => real()();
  RealColumn get destinationAmount => real().nullable()();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  TextColumn get comment => text().nullable().withLength(max: 200)();
  TextColumn get date => text()();
  TextColumn get time => text().nullable()();
}
