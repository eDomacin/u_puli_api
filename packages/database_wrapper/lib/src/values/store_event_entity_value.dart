class StoreEventEntityValue {
  StoreEventEntityValue({
    required this.title,
    required this.date,
    required this.location,
    required this.uri,
    required this.imageUri,
    required String description,
  })
    // NOTE: truncating description to 500 characters if it is longer
    // TODO: maybe this should be done elsewhere, but for now it is here
    : description = description.padRight(500).substring(0, 500);

  final String title;
  final DateTime date;
  final String location;
  final Uri uri;
  final Uri imageUri;
  final String description;
}
