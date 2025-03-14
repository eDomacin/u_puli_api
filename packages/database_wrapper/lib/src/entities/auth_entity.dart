import 'package:drift/drift.dart';

class AuthEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text()();
  TextColumn get password => text()();
}
