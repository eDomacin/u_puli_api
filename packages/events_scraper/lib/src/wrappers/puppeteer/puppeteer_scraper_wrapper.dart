import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';
import 'package:puppeteer/puppeteer.dart';

/// Interface for Puppeteer scraper wrappers.
///
/// NOTE: This class should be **extended** rather than *implemented*.
abstract class PuppeteerScraperWrapper with _PuppeteerScraperWrapperMixin {
  const PuppeteerScraperWrapper();
  abstract final Uri uri;
  abstract final String name;
  Future<Set<ScrapedEventEntity>> getEvents();
}

mixin _PuppeteerScraperWrapperMixin {
  // TODO make this available only inside - maybe used sealed classes or part files - or maybe irrelevant
  Future<Browser> getBrowser() async {
    final Browser browser = await puppeteer.launch(
      // NOTE: Not working on linux, or in docker. "args" works tho
      // headless: true,
      // noSandboxFlag: true,
      args: [
        // list of flags that worked - # https://github.com/puppeteer/puppeteer/issues/11028
        // TODO this probably should not be enabled - i guess in docker, will need to run as non-root
        // '--no-sandbox',
        // '--headless',
        /////////////////////
        // new try
        '--use-fake-device-for-media-stream',
        '--no-zygote',
        '--allow-file-access-from-files',
        '--no-sandbox',
        '--headless',
        '--disable-web-security',
        '--disable-features=IsolateOrigins',
        '--disable-site-isolation-trials',
        '--disable-gpu',
        '--disable-dev-shm-usage',
        '--disk-cache-dir=/dev/null',
      ],
    );

    return browser;
  }
}
