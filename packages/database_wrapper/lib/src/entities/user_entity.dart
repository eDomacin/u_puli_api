import 'package:database_wrapper/src/entities/auth_entity.dart';
import 'package:drift/drift.dart';

/// Should have 1:1 relationship with [AuthEntity]
//
// NOTE: [AuthEntity] imported because migrator needs to reference it

// NOTE: This is possible, according to docs
// @TableIndex(name: "user_entity_auth_id_idx", columns: {#authId})
// @TableIndex.sql('CREATE INDEX user_entity_auth_id_idx ON user_entity(auth_id);')
// NOTE: This will generate code of [Index] type, but we wont use it in migration because it uses SQLite specific syntax
@TableIndex.sql(
  'CREATE INDEX user_entity_auth_id_idx ON user_entity (auth_id);',
)
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
