import "package:flutter/material.dart";

import "package:finances/models.dart";
import "package:finances/pages.dart";
import "package:finances/services.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await services.init();
  await models.init();
  await models.initFromOthers();
  runApp(const FinancesApp());
}

/// The main app widget.
class FinancesApp extends StatelessWidget {
  /// A const constructor.
  const FinancesApp();

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: services.settings.theme,
    builder: (context, value, _) => MaterialApp.router(
      title: "Flutter Demo",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0094A9)),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(brightness: .dark, seedColor: const Color(0xff0094A9)),
      ),
      themeMode: value,
      routerConfig: router,
    ),
  );
}
