import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  const EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.url,
    required this.imageUrl,
  });

  final int id;
  final String title;
  /* TODO this should be actually converted to int here */
  final DateTime date;
  final String location;
  final String description;
  final String url;
  final String imageUrl;

  // TODO this should probably have toJson method to use when sending to client

  @override
  List<Object?> get props => [
    id,
    title,
    date,
    location,
    description,
    url,
    imageUrl,
  ];
}
