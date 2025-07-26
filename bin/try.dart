import "package:timezone/data/latest.dart" as tzdata;
import "package:timezone/timezone.dart" as tz;

Future<void> main(List<String> args) async {
  tzdata.initializeTimeZones();

  final croatiaZone = 'Europe/Zagreb';
  final croatiaLocation = tz.getLocation(croatiaZone);

  final londonZone = 'Europe/London';
  final londonLocation = tz.getLocation(londonZone);

  final now = DateTime.now();

  // ok, this can create a date time in UTC
  final utcNow = now.toUtc();

  final croatiaNow = tz.TZDateTime.from(utcNow, croatiaLocation);

  final londonNow = tz.TZDateTime.from(utcNow, londonLocation);

  final nowMillis = now.millisecondsSinceEpoch;
  final croatiaNowMillis = croatiaNow.millisecondsSinceEpoch;
  final londonNowMillis = londonNow.millisecondsSinceEpoch;

  print("nowMillis: $nowMillis");
  print("croatiaNowMillis: $croatiaNowMillis");
  print("londonNowMillis: $londonNowMillis");

  final croatiaDateTime = croatiaNow.native;
  final croatiaUTCDateTime = croatiaNow.toUtc();
  print('Croatia Timezone: $croatiaZone');
}

void _someDecodedUrlStuff() {
  // // final scraper = GkpuPuppeteerScraperWrapper();
  // final scraper = RojcPuppeteerScraperWrapper();

  // final events = await scraper.getEvents();

  // print('Events: $events');

  // final string = "jello";

  // final subsstring = string.substring(0, 200);

  // print('Substring: $subsstring');

  // final something = "hhhh";

  // final padded = something.padRight(2, '0');
  // print('Padded: $padded');

  final component = "ids=1,2,3&fromDate=1751310762670";

  final encoded = Uri.encodeQueryComponent(component);
  final encodedComponent = Uri.encodeComponent(component);

  final decoded = Uri.decodeQueryComponent(encoded);
  final decodedComponent = Uri.decodeComponent(encodedComponent);

  print('Encoded component: $encoded');

  // Uri.decodeQueryComponent(encodedComponent)
}


/* 
- ok, so the thing is - when we create date - i guess we save it in what? local time zone?
- and then when we receive it in kotlin, it is expected to be in utc - so we convert it to local
- but it actually is not in utc - it is in time local to frakfurt, because that is where the server is? or database, or something


- so lets use to utc specifically






 */