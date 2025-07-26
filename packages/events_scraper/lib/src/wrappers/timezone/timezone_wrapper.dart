import "package:timezone/data/latest.dart" as tzdate;
import "package:timezone/timezone.dart" as tz;

abstract class TimezoneWrapper {
  static initializeTimeZones() {
    tzdate.initializeTimeZones();
  }

  static DateTime convertToUtc({
    required DateTime dateTime,
    required TimezoneLocation location,
  }) {
    final tzLocation = tz.getLocation(location.name);
    final tzDateTime = tz.TZDateTime(
      tzLocation,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
    final utcTzDateTime = tzDateTime.toUtc();

    final nativeUtcDateTime = utcTzDateTime.native;

    print("!!!!!!!!!!!!! -------------- !!!!!!!!!!!!!!!");

    print("original dateTime: $dateTime");
    print("tzDateTime: $tzDateTime");
    print("utcTzDateTime: $utcTzDateTime");
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
