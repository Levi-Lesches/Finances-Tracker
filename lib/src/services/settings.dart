import "dart:convert";
import "dart:io";

import "package:finances/data.dart";
import "package:finances/services.dart";
import "package:flutter/material.dart";

class SettingsService extends Service {
  ValueNotifier<ThemeMode> theme = ValueNotifier(.system);
  File get file => File("${Services.dir.path}/settings.json");

  @override
  Future<void> init() async {
    if (!file.existsSync()) {
      await save();
    }
    final json = await file.readAsString();
    final data = jsonDecode(json) as Json;
    theme.value = data.maybe("theme", ThemeMode.values.byName) ?? ThemeMode.system;
  }

  void toggleTheme() {
    theme.value = switch (theme.value) {
      .dark => .light,
      .light => .system,
      .system => .dark,
    };
    save();
  }

  Future<void> save() => file.writeAsString(jsonEncode({"theme": theme.value.name}));
}
