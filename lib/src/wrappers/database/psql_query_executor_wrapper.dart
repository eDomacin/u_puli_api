// import 'package:drift/drift.dart';
// import 'package:drift_postgres/drift_postgres.dart';
// import 'package:env_vars_wrapper/env_vars_wrapper.dart';
// import 'package:postgres/postgres.dart';
// // import 'package:u_puli_api/src/wrappers/env_vars/env_vars_wrapper.dart';

// class PsqlQueryExecutorWrapper {
//   const PsqlQueryExecutorWrapper(EnvVarsDBWrapper envVarsDBWrapper)
//       : _envVarsDBWrapper = envVarsDBWrapper;

//   final EnvVarsDBWrapper _envVarsDBWrapper;

//   QueryExecutor get queryExecuter {
//     final PgDatabase pgDatabase = PgDatabase(
//       endpoint: Endpoint(
//         host: _envVarsDBWrapper.pgHost,
//         port: _envVarsDBWrapper.pgPort,
//         username: _envVarsDBWrapper.pgUser,
//         password: _envVarsDBWrapper.pgPassword,
//         database: _envVarsDBWrapper.pgDatabase,
//       ),
//       settings: ConnectionSettings(
//         sslMode: SslMode.require,
//         onOpen: (connection) async {
//           print("Connected to database");
//         },
//       ),
//     );

//     return pgDatabase;
//   }
// }
