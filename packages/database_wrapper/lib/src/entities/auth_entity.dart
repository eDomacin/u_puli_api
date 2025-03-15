import 'package:drift/drift.dart';

class AuthEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get password => text().nullable()();
  IntColumn get authType => intEnum<AuthType>()();
}

enum AuthType {
  emailPassword, // 0
  google, // 1
}
