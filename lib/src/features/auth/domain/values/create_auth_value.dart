import 'package:equatable/equatable.dart';
import 'package:database_wrapper/database_wrapper.dart';

sealed class CreateAuthValue extends Equatable {
  const CreateAuthValue({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.hashedPassword,
    required this.authType,
  });
  final String firstName;
  final String lastName;
  final String email;
  final String? hashedPassword;
  final AuthType authType;

  @override
  List<Object?> get props => [
    email,
    hashedPassword,
    authType,
    firstName,
    lastName,
  ];
}

class CreateEmailPasswordAuthEntityDataValue extends CreateAuthValue {
  const CreateEmailPasswordAuthEntityDataValue({
    required super.firstName,
    required super.lastName,
    required super.email,
    // specify non-null hashedPassword
    required String super.hashedPassword,
  }) : super(authType: AuthType.emailPassword);
}

class CreateGoogleAuthEntityDataValue extends CreateAuthValue {
  const CreateGoogleAuthEntityDataValue({
    required super.firstName,
    required super.lastName,
    required super.email,
  }) : super(authType: AuthType.google, hashedPassword: null);
}
