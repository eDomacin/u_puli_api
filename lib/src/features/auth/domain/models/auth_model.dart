import 'package:database_wrapper/database_wrapper.dart';

// TODO this is not meant for sending to the client
class AuthModel {
  // TODO this should have toJson method probably - not really - this should be renamed to AuthValue or something - this data is not meant for the client

  const AuthModel({
    required this.id,
    required this.email,
    required this.authType,
    this.password,
  });

  final int id;
  final String email;
  final AuthType authType;
  final String? password;
}
