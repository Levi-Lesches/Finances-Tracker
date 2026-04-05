import "dart:convert";
import "dart:io";

import "package:finances/data.dart";
import "package:path_provider/path_provider.dart";
import "package:file_picker/file_picker.dart";

import "service.dart";

class DatabaseService extends Service {
  late Directory dir;
  File get file => File("${dir.path}/data.json");
  bool get needsOnboarding => !file.existsSync();

  @override
  Future<void> init() async {
    dir = await getApplicationSupportDirectory();
    if (needsOnboarding) return;
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString) as Json;
    income = Income.fromJson(json["income"]);
    expenses = json.parseList("expenses", Expense.fromJson);
    wallet = Money.fromJson(json["wallet"]);
    goals = json.parseList("goals", SavingsGoal.fromJson);
  }

  late Income income;
  List<Expense> expenses = [];
  List<SavingsGoal> goals = [];
  Money wallet = Money.zero;

  Future<void> save() async {
    final json = {
      "income": income,
      "expenses": expenses,
      "goals": goals,
      "wallet": wallet.toJson(),
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
