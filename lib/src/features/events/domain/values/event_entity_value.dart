import 'package:equatable/equatable.dart';

class EventEntityValue extends Equatable {
  const EventEntityValue({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
  });

  final int id;
  final String title;
  final DateTime date;
  final String location;

  @override
  List<Object?> get props => [id, title, date, location];
}
