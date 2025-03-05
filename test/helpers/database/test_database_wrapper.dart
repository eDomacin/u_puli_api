import 'package:drift/drift.dart';
// import 'package:u_puli_api/src/wrappers/database/database_wrapper.dart';
import "package:database_wrapper/database_wrapper.dart";

class TestDatabaseWrapper {
  TestDatabaseWrapper(this.databaseWrapper);

  final DatabaseWrapper databaseWrapper;

  late final List<TableInfo> _orderedTablesForDeletion = [
    databaseWrapper.driftWrapper.eventEntity,
  ];

  Future<void> close() async {
    await databaseWrapper.driftWrapper.close();
  }

  Future<void> clearAll() async {
    for (final table in _orderedTablesForDeletion) {
      await databaseWrapper.driftWrapper.delete(table).go();
    }
  }
}

TestDatabaseWrapper getTestDatabaseWrapper() {
  final QueryExecutor queryExecutor =
      TestPsqlQueryExecutorWrapper().queryExecuter;
  final DatabaseWrapper databaseWrapper = DatabaseWrapper(queryExecutor);

  databaseWrapper.initialize();

  return TestDatabaseWrapper(databaseWrapper);
}

// class _TestPsqlQueryExecutorWrapper {
//   final QueryExecutor queryExecuter = PgDatabase(
//       endpoint: Endpoint(
//         host: 'localhost',
//         port: 5432,
//         username: 'admin',
//         password: 'root',
//         database: 'postgres',
//       ),
//       settings: ConnectionSettings(
//         sslMode: SslMode.disable,
//         onOpen: (connection) async {
//           print("Connected to test database");
//         },
//       ));
// }
