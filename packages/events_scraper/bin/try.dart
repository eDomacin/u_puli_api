import 'package:event_scraper/src/wrappers/puppeteer/hnl_puppeteer_scraper_wraper.dart';
import 'package:timezone/data/latest.dart' as TimezoneWrapper;

Future<void> main(List<String> args) async {
  TimezoneWrapper.initializeTimeZones();

  // await _scrapeHNLIstraEvents();
  // _someDecodedUrlStuff();
}

Future<void> _scrapeHNLIstraEvents() async {
  final hnlScraper = HnlPuppeteerScraperWrapper();
  final events = await hnlScraper.getEvents();

  print('Events: $events');
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
