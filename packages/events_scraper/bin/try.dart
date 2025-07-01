import 'package:event_scraper/src/wrappers/puppeteer/gkpu_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/ink_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/kotac_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/rojc_puppeteer_scraper_wrapper.dart';

Future<void> main(List<String> args) async {
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
