import "package:timezone/data/latest.dart" as tzdate;
import "package:timezone/timezone.dart" as tz;

abstract class TimezoneWrapper {
  static initializeTimeZones() {
    tzdate.initializeTimeZones();
  }

  static DateTime toLocationDateInUTC(
    TimezoneLocation location, {
    required int year,
    required int month,
    required int day,
    required int hours,
    required int minutes,
  }) {
    final tzLocation = tz.getLocation(location.name);
    final locationTZDateTime = tz.TZDateTime(
      tzLocation,
      year,
      month,
      day,
      hours,
      minutes,

      // dateTime.year,
      // dateTime.month,
      // dateTime.day,
      // dateTime.hour,
      // dateTime.minute,
      // dateTime.second,
      // dateTime.millisecond,
      // dateTime.microsecond,
    );
    final utcTZDateTime = locationTZDateTime.toUtc();

    final nativeUtcDateTime = utcTZDateTime.native;

    print("!!!!!!!!!!!!! -------------- !!!!!!!!!!!!!!!");
    print("tzDateTime: $locationTZDateTime");
    print("utcTzDateTime: $utcTZDateTime");
    print("nativeUtcDateTime: $nativeUtcDateTime");

    print("!!!!!!!!!!!!! -------------- !!!!!!!!!!!!!!!");

    // Return the DateTime in UTC
    return nativeUtcDateTime;
  }
}

enum TimezoneLocation {
  croatia._('Europe/Zagreb');

  const TimezoneLocation._(this.name);
  final String name;
}
