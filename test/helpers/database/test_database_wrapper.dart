import "package:database_wrapper/database_wrapper.dart";

class TestDatabaseWrapper {
  TestDatabaseWrapper(this.databaseWrapper);

  final DatabaseWrapper databaseWrapper;

  late final List<TableInfo> _orderedTablesForDeletion = [
    // databaseWrapper.driftWrapper.eventEntity,
    databaseWrapper.eventsRepo,
    databaseWrapper.usersRepo,
    databaseWrapper.authsRepo,
  ];

  Future<void> close() async {
    await databaseWrapper.close();
  }

  Future<void> clearAll() async {
    for (final table in _orderedTablesForDeletion) {
      await databaseWrapper.deleteTableRows(table);
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
