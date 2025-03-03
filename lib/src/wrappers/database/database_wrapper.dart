import 'package:drift/drift.dart';
import 'package:u_puli_api/src/wrappers/database/psql_query_executor_wrapper.dart';
import 'package:u_puli_api/src/wrappers/drift/drift_wrapper.dart';
import 'package:u_puli_api/src/wrappers/env_vars/env_vars_wrapper.dart';

class DatabaseWrapper {
  DatabaseWrapper._(this._executor);
  final QueryExecutor _executor;

  factory DatabaseWrapper.app({
    required EnvVarsDBWrapper envVarsDBWrapper,
  }) {
    final PsqlQueryExecutorWrapper executor =
        PsqlQueryExecutorWrapper(envVarsDBWrapper);

    return DatabaseWrapper._(executor.queryExecuter);
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

  // repos
  $EventEntityTable get eventsRepo => driftWrapper.eventEntity;

  Future<void> logDbTime() async {
    final List<String> dbCurrentTime =
        await driftWrapper.current_timestamp().get();

    print("Current database time on open: $dbCurrentTime");
  }
}
