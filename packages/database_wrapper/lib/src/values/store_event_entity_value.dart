class StoreEventEntityValue {
  const StoreEventEntityValue({
    required this.title,
    required this.date,
    required this.location,
    required this.uri,
    required this.imageUri,
    required this.description,
  });

  final String title;
  final DateTime date;
  final String location;
  final Uri uri;
  final Uri imageUri;
  final String description;
}
