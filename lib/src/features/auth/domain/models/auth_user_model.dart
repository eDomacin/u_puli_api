// this is data to be later returned to the client, if the auth passes - register, login, getAuth (this is only in case authToken is valid when this is called)

// TODO this should have to json probably
// TODO could have a Model interface to implement
class AuthUserModel {
  AuthUserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  final int userId;
  final String firstName;
  final String lastName;
  final String email;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
