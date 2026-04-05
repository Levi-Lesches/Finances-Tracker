/// Defines and manages the different services used by the app.
library;

import "dart:io";

import "package:path_provider/path_provider.dart";

import "";

export "src/services/service.dart";
export "src/services/settings.dart";
export "src/services/database.dart";

/// A [Service] that manages all other services used by the app.
class Services extends Service {
  /// Prevents other instances of this class from being created.
  Services._();

  // Define your services here
  final database = DatabaseService();
  final settings = SettingsService();

  /// The different services to initialize, in this order.
  List<Service> get services => [database, settings];
  static late Directory dir;

  @override
  Future<void> init() async {
    dir = await getApplicationSupportDirectory();
    for (final service in services) {
      await service.init();
    }
  }
}

/// The global services object.
final services = Services._();
