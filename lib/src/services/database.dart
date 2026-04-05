import "dart:convert";
import "dart:io";

import "package:finances/data.dart";
import "package:path_provider/path_provider.dart";

import "service.dart";

class DatabaseService extends Service {
  late final Directory dir;
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
    payments = json.parseList("payments", Payment.fromJson);
    wallet = Money.fromJson(json["wallet"]);
    goals = json.parseList("goals", SavingsGoal.fromJson);
  }

  late Income income;
  List<Expense> expenses = [];
  List<Payment> payments = [];
  List<SavingsGoal> goals = [];
  Money wallet = Money(0);

  Future<void> save() async {
    final json = {
      "income": income,
      "expenses": expenses,
      "payments": payments,
      "goals": goals,
      "wallet": wallet.toJson(),
    };
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(json));
  }
}
