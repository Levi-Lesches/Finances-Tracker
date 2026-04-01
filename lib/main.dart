import "package:flutter/material.dart";

import "package:finances/models.dart";
import "package:finances/pages.dart";
import "package:finances/services.dart";

Future<void> main() async {
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
  Widget build(BuildContext context) => MaterialApp.router(
    title: "Flutter Demo",
    theme: ThemeData(
      useMaterial3: true,
    ),
    routerConfig: router,
  );
}
