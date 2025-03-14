import 'dart:io';

abstract interface class EnvVarsWrapper {
  // EnvVarsDBWrapper get envVarsDBWrapper;

  factory EnvVarsWrapper() => _EnvVarsWrapperImpl();

  // db
  String get pgHost;
  String get pgDatabase;
  String get pgUser;
  String get pgPassword;
  int get pgPort;

  // auth
  String get jwtAccessSecret;
  String get jwtRefreshSecret;
}

class _EnvVarsWrapperImpl implements EnvVarsWrapper {
  _EnvVarsWrapperImpl();

  // db
  final String _pgHost = Platform.environment['PG_HOST']!;
  final String _pgDatabase = Platform.environment['PG_DATABASE']!;
  final String _pgUser = Platform.environment['PG_USER']!;
  final String _pgPassword = Platform.environment['PG_PASSWORD']!;
  final int _pgPort = int.parse(Platform.environment['PG_PORT']!);

  @override
  String get pgHost => _pgHost;
  @override
  String get pgDatabase => _pgDatabase;
  @override
  String get pgUser => _pgUser;
  @override
  String get pgPassword => _pgPassword;
  @override
  int get pgPort => _pgPort;

  // auth
  final String _jwtAccessSecret = Platform.environment['JWT_ACCESS_SECRET']!;
  final String _jwtRefreshSecret = Platform.environment['JWT_REFRESH_SECRET']!;

  @override
  String get jwtAccessSecret => _jwtAccessSecret;
  @override
  String get jwtRefreshSecret => _jwtRefreshSecret;

  // @override
  // EnvVarsDBWrapper get envVarsDBWrapper => EnvVarsDBWrapper(
  //   pgHost: _pgHost,
  //   pgDatabase: _pgDatabase,
  //   pgUser: _pgUser,
  //   pgPassword: _pgPassword,
  //   pgPort: _pgPort,
  // );
}

// class EnvVarsDBWrapper {
//   const EnvVarsDBWrapper({
//     required this.pgHost,
//     required this.pgDatabase,
//     required this.pgUser,
//     required this.pgPassword,
//     required this.pgPort,
//   });

//   final String pgHost;
//   final String pgDatabase;
//   final String pgUser;
//   final String pgPassword;
//   final int pgPort;
// }
