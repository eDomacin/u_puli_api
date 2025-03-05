import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart';

class TestPsqlQueryExecutorWrapper {
  final QueryExecutor queryExecuter = PgDatabase(
    endpoint: Endpoint(
      host: 'localhost',
      port: 5432,
      username: 'admin',
      password: 'root',
      database: 'postgres',
    ),
    settings: ConnectionSettings(
      sslMode: SslMode.disable,
      onOpen: (connection) async {
        print("Connected to test database");
      },
    ),
  );
}
