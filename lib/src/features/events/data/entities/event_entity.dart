class EventEntity {
  const EventEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
  });

  final int id;
  final String title;
  final DateTime date;
  final String location;
}
