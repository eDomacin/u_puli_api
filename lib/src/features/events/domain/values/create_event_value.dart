import 'package:equatable/equatable.dart';

/// Class that represents the value of a event being created
class CreateEventValue extends Equatable {
  const CreateEventValue({
    required this.title,
    required this.location,
    required this.date,
    required this.uri,
    required this.imageUri,
  });

  final String title;
  final String location;
  final DateTime date;
  final Uri uri;
  final Uri imageUri;

  @override
  List<Object?> get props => [title, date, location, uri, imageUri];
}
