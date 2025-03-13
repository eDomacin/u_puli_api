class UserEntity {
  UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.authId,
  });

  final int id;
  final String firstName;
  final String lastName;
  // TODO will need to put index on this when have db table
  final int authId;
}
