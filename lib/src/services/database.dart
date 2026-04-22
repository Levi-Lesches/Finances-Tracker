import "dart:convert";
import "dart:io";

import "package:finances/data.dart";
import "package:finances/services.dart";
import "package:file_picker/file_picker.dart";

class HistoryEntry {
  final List<Expense> expenses;
  final Money wallet;
  final DateTime date;

  HistoryEntry({required this.expenses, required this.wallet, required this.date});

  HistoryEntry.fromJson(Json json)
    : expenses = json.parseList("expenses", Expense.fromJson),
      wallet = Money.fromJson(json["wallet"]),
      date = DateTime.parse(json["date"]);

  Json toJson() => {"expenses": expenses, "wallet": wallet, "date": date.toIso8601String()};
}

class DatabaseService extends Service {
  File get file => File("${Services.dir.path}/data.json");
  bool get needsOnboarding => !file.existsSync();

  @override
  Future<void> init() async {
    if (needsOnboarding) return;
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString) as Json;
    income = Income.fromJson(json["income"]);
    expenses = json.parseList("expenses", Expense.fromJson);
    wallet = Money.fromJson(json["wallet"]);
    goals = json.parseList("goals", SavingsGoal.fromJson);
    if (json.containsKey("history")) {
      history = json.parseList("history", HistoryEntry.fromJson);
    }
    if (json.containsKey("paychecks")) {
      paychecks = Money.fromJson(json["paychecks"]);
    }
  }

  late Income income;
  List<Expense> expenses = [];
  List<SavingsGoal> goals = [];
  List<HistoryEntry> history = [];
  Money wallet = Money.zero;
  Money paychecks = Money.zero;

  Future<void> save() async {
    final json = {
      "income": income,
      "expenses": expenses,
      "goals": goals,
      "wallet": wallet.toJson(),
      "history": history,
      "paychecks": paychecks,
    };
    await file.create(recursive: true);
    const encoder = JsonEncoder.withIndent("  ");
    await file.writeAsString(encoder.convert(json));
  }

  Future<void> export() async {
    final bytes = await file.readAsBytes();
    await FilePicker.platform.saveFile(
      dialogTitle: "Export data",
      type: FileType.custom,
      fileName: "finances.json",
      allowedExtensions: [".json"],
      bytes: bytes,
    );
  }

  Future<void> import() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: [".json"],
      dialogTitle: "Import data",
      type: .custom,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final bytes = result.files.first.bytes;
    if (bytes == null) return;
    await file.writeAsBytes(bytes);
    await init();
  }
}
