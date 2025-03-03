import 'package:drift/drift.dart';

class DriftMigratorWrapper {
  DriftMigratorWrapper();

  final MigrationStrategy migrationStrategy = MigrationStrategy(
    beforeOpen: (details) async {},
    onCreate: (m) async {},
    onUpgrade: (m, from, to) async {},
  );
}
