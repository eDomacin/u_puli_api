import 'package:database_wrapper/src/query_executors/psql_query_executor_wrapper.dart';
import 'package:database_wrapper/src/values/database_endpoint_data_value.dart';
import 'package:database_wrapper/src/wrappers/drift/drift_wrapper.dart';

class DatabaseWrapper {
  DatabaseWrapper(this._executor);
  final QueryExecutor _executor;

  factory DatabaseWrapper.app({
    required DatabaseEndpointDataValue endpointData,
  }) {
    final PsqlQueryExecutorWrapper executor = PsqlQueryExecutorWrapper(
      endpointData,
    );

    return DatabaseWrapper(executor.queryExecuter);
  }

  late final DriftWrapper _driftWrapper;

  // repos
  $EventEntityTable get eventsRepo => _driftWrapper.eventEntity;
  $AuthEntityTable get authsRepo => _driftWrapper.authEntity;
  $UserEntityTable get usersRepo => _driftWrapper.userEntity;

  void initialize() {
    try {
      _driftWrapper = DriftWrapper(_executor);
      logDbTime();
    } catch (e) {
      print("There was an error initializing the database: $e");
      rethrow;
    }
  }

  Future<int> deleteTableRows<T extends Table, D>(TableInfo<T, D> table) async {
    final deletedRowsCount = _driftWrapper.delete(table).go();

    return deletedRowsCount;
  }

  Future<T> transaction<T>(
    Future<T> Function() action, {
    bool requireNew = false,
  }) {
    return _driftWrapper.transaction(action, requireNew: requireNew);
  }

  Future<void> close() async {
    await _driftWrapper.close();
    print("Database closed");
  }

  Future<void> logDbTime() async {
    final List<String> dbCurrentTime =
        await _driftWrapper.current_timestamp().get();

    print("Current database time on open: $dbCurrentTime");
  }
}
