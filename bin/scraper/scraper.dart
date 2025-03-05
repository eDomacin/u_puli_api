import 'package:u_puli_api/src/features/scraper/temp_scraper_db_storer.dart';
import 'package:u_puli_api/src/wrappers/database/database_wrapper.dart';
import 'package:u_puli_api/src/wrappers/env_vars/env_vars_wrapper.dart';
import 'package:u_puli_api/src/wrappers/get_id/get_it_wrapper.dart';

Future<void> main(List<String> args) async {
  final events = List.generate(10, (i) {
    final event = StoreEventEntityValue(
      title: 'Event $i',
      date: DateTime.now().add(Duration(days: i)),
      // date: DateTime(2022, 1, 1),
      location: 'Location $i',
    );

    return event;
  });

  final envVarsDBWrapper = EnvVarsWrapper().envVarsDBWrapper;

  final databaseWrapper = DatabaseWrapper.app(
    envVarsDBWrapper: envVarsDBWrapper,
  );

  databaseWrapper.initialize();

  // final databaseWrapper = getIt.get<DatabaseWrapper>();

  final TempScraperDbStorer tempScraperDbStorer =
      TempScraperDbStorer(databaseWrapper);

  await tempScraperDbStorer.storeEvents(events);

  await databaseWrapper.driftWrapper.close();
}
