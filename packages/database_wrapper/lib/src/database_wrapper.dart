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

  late final DriftWrapper driftWrapper;

  void initialize() {
    try {
      driftWrapper = DriftWrapper(_executor);
      logDbTime();
    } catch (e) {
      print("There was an error initializing the database: $e");
      rethrow;
    }
  }

  Future<void> close() async {
    await driftWrapper.close();
    print("Database closed");
  }

  // repos
  $EventEntityTable get eventsRepo => driftWrapper.eventEntity;

  Future<void> logDbTime() async {
    final List<String> dbCurrentTime =
        await driftWrapper.current_timestamp().get();

    print("Current database time on open: $dbCurrentTime");
  }
}
