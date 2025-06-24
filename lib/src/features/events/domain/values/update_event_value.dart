import 'package:equatable/equatable.dart';

/// Class that represents the value of a event being updated
class UpdateEventValue extends Equatable {
  const UpdateEventValue({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.uri,
    required this.imageUri,
    required this.description,
    /* TODO add missing fields here  */
  });

  final int id;
  final String? title;
  final String? location;
  final DateTime? date;
  final Uri? uri;
  final Uri? imageUri;
  final String? description;

  @override
  List<Object?> get props => [
    /* TODO not sure about id - i did not add it initailly, but now i cannot remember why i did not add it  */
    id,
    title,
    date,
    location,
    uri,
    imageUri,
    description,
  ];
}
