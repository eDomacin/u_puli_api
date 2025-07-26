class StoreEventEntityValue {
  StoreEventEntityValue({
    required this.title,

    // required this.date,
    required this.location,
    required this.uri,
    required this.imageUri,
    required String description,
    required DateTime date,
    // NOTE: converting date to UTC, so it is always in UTC
  })
    // NOTE: truncating description to 500 characters if it is longer
    // TODO: maybe this should be done elsewhere, but for now it is here
    : description = description.trim().padRight(500).substring(0, 500),
       date = date.toUtc() {
    final newDescription = description.trim().padRight(500);

    final utcDate = date.toUtc();

    print("original date!!!!!!!!!!!!!!!!: $date");
    print("utc date!!!!!!!!!!!!!!: $utcDate");
  }

  final String title;
  final DateTime date;
  final String location;
  final Uri uri;
  final Uri imageUri;
  final String description;
}
