import 'package:event_scraper/src/wrappers/puppeteer/gkpu_puppeteer_scraper_wrapper.dart';

Future<void> main(List<String> args) async {
  final gkpuScraoer = GkpuPuppeteerScraperWrapper();

  final events = await gkpuScraoer.getEvents();

  print('Events: $events');
}
