import 'dart:io';

class EnvVarsWrapper {
  EnvVarsWrapper();

  final String _pgHost = Platform.environment['PG_HOST']!;
  final String _pgDatabase = Platform.environment['PG_DATABASE']!;
  final String _pgUser = Platform.environment['PG_USER']!;
  final String _pgPassword = Platform.environment['PG_PASSWORD']!;
  final int _pgPort = int.parse(Platform.environment['PG_PORT']!);

  EnvVarsDBWrapper get envVarsDBWrapper => EnvVarsDBWrapper(
        pgHost: _pgHost,
        pgDatabase: _pgDatabase,
        pgUser: _pgUser,
        pgPassword: _pgPassword,
        pgPort: _pgPort,
      );
}

class EnvVarsDBWrapper {
  const EnvVarsDBWrapper({
    required this.pgHost,
    required this.pgDatabase,
    required this.pgUser,
    required this.pgPassword,
    required this.pgPort,
  });

  final String pgHost;
  final String pgDatabase;
  final String pgUser;
  final String pgPassword;
  final int pgPort;
}
