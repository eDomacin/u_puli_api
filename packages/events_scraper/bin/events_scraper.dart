import 'package:event_scraper/src/run_events_scraper.dart';
import 'package:event_scraper/src/wrappers/timezone/timezone_wrapper.dart';

Future<void> main() async {
  TimezoneWrapper.initializeTimeZones();
  runEventsScraper();
}
