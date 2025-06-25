import 'package:event_scraper/src/wrappers/puppeteer/gkpu_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/ink_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/kotac_puppeteer_scraper_wrapper.dart';
import 'package:event_scraper/src/wrappers/puppeteer/rojc_puppeteer_scraper_wrapper.dart';

Future<void> main(List<String> args) async {
  // final scraper = GkpuPuppeteerScraperWrapper();
  final scraper = RojcPuppeteerScraperWrapper();

  final events = await scraper.getEvents();

  print('Events: $events');
}
