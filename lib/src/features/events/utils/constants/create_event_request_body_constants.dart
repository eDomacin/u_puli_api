enum CreateEventRequestBodyConstants {
  TITLE._('title'),
  DATE._('date'),
  LOCATION._('location'),
  URL._('url'),
  IMAGE_URL._('imageUrl'),
  DESCRIPTION._('description');

  const CreateEventRequestBodyConstants._(this.value);
  final String value;
}
