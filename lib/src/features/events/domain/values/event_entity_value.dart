import 'package:equatable/equatable.dart';

class EventEntityValue extends Equatable {
  const EventEntityValue({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.url,
    required this.imageUrl,
    required this.description,
    /* TODO add missing fields here  */
  });

  final int id;
  final String title;
  final DateTime date;
  final String location;
  final String url;
  final String imageUrl;
  final String description;

  @override
  List<Object?> get props => [id, title, date, location];
}
