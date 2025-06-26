import 'package:equatable/equatable.dart';

/// Class that represents the value of a event being created
class CreateEventValue extends Equatable {
  CreateEventValue({
    required this.title,
    required this.location,
    required this.date,
    required this.uri,
    required this.imageUri,
    required String description,
  })
    // NOTE: truncating description to 500 characters if it is longer
    // TODO: maybe this should be done elsewhere, but for now it is here
    : description = description.padRight(500).substring(0, 500);

  final String title;
  final String location;
  final DateTime date;
  final Uri uri;
  final Uri imageUri;
  final String description;

  @override
  List<Object?> get props => [
    title,
    date,
    location,
    uri,
    imageUri,
    description,
  ];
}
