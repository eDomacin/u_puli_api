class DatabaseEndpointDataValue {
  const DatabaseEndpointDataValue({
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
