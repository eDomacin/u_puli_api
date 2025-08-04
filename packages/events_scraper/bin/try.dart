import 'package:event_scraper/src/wrappers/puppeteer/eventim_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/hnl_puppeteer_scraper_wraper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/pdpu_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/pulainfo_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/rojc_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/sp_puppeteer_scraper_wrapper.dart';
import 'package:timezone/data/latest.dart' as TimezoneWrapper;

Future<void> main(List<String> args) async {
  TimezoneWrapper.initializeTimeZones();

  // final text = "🕓 9:00 - 11:30";

  // final RegExp regExp = RegExp(r'(\d{1,2}):(\d{2})');

  // final match = regExp.firstMatch(text);

  // if (match == null) {
  //   throw Exception("No match found in the text: $text");
  // }

  // final hours = int.parse(match.group(1)!);
  // final minutes = int.parse(match.group(2)!);

  // print('Hours: $hours, Minutes: $minutes');

  // await _scrapeSPEvents();
  // await _scrapePulainfoEvents();

  // await _scrapeHNLIstraEvents();
  // _someDecodedUrlStuff();

  // await _scrapePDPUEvents();
  // await _scrapeRojcEvents();
  await scrapeEventimEvents();
}

Future<void> scrapeEventimEvents() async {
  final eventimScraper = EventimPuppeteerScraperWrapper();
  final events = await eventimScraper.getEvents();

  print('Events: $events');
}

Future<void> _scrapeRojcEvents() async {
  final rojcScraper = RojcPuppeteerScraperWrapper();
  final events = await rojcScraper.getEvents();

  print('Events: $events');
}

Future<void> _scrapePDPUEvents() async {
  final pdpuScraper = PDPUPuppeteerScrapperWrapper();
  final events = await pdpuScraper.getEvents();

  print('Events: $events');
}

Future<void> _scrapePulainfoEvents() async {
  final pulainfoScraper = PulainfoPuppeteerScraperWrapper();
  final events = await pulainfoScraper.getEvents();

  print('Events: $events');
}

Future<void> _scrapeSPEvents() async {
  final spScraper = SpPuppeteerScraperWrapper();
  final events = await spScraper.getEvents();

  print('Events: $events');
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
