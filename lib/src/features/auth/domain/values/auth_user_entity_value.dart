class AuthUserEntityValue {
  AuthUserEntityValue({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  // TODO will probably have role later - admin, user, or something else
}
