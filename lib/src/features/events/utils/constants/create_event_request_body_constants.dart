enum CreateEventRequestBodyConstants {
  TITLE._('title'),
  DATE._('date'),
  LOCATION._('location'),
  URI._('uri'),
  IMAGE_URI._('imageUri');

  const CreateEventRequestBodyConstants._(this.value);
  final String value;
}
