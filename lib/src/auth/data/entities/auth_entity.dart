// TODO will be moved to database wrapper eventually
// TODO maybe neitties should be called tables instead?
class AuthEntity {
  AuthEntity({
    required this.id,
    required this.email,
    this.password,
    required this.authType,
  });

  final int id;
  // TODO this should be unique
  final String email;
  final String? password;
  final AuthType authType;
}

// TODO will use this in real implementation
// lib/src/features/player_match_participations/data/entities/player_match_participation_entity.dart
enum AuthType { emailPassword, google }
