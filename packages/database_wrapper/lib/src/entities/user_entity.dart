import 'package:drift/drift.dart';

class UserEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  IntColumn get authId => integer()();

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (auth_id) REFERENCES auth_entity(id)',
  ];
}
