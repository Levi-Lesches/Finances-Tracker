import "dart:convert";
import "dart:io";

import "package:finances/data.dart";

import "service.dart";

class DatabaseService extends Service {
  late final Directory dir;
  File get file => File("${dir.path}/data.json");

  @override
  Future<void> init() async {
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString) as Json;
    income = Income.fromJson(json["income"]);
    expenses = json.parseList("expenses", Expense.fromJson);
    payments = json.parseList("payments", Payment.fromJson);
    goals = json.parseList("goals", SavingsGoal.fromJson);
  }

  late final Income income;
  late final List<Expense> expenses;
  late final List<Payment> payments;
  late final List<SavingsGoal> goals;

  Future<void> save() async {
    final json = {
      "income": income,
      "expenses": expenses,
      "payments": payments,
      "goals": goals,
    };
    await file.writeAsString(jsonEncode(json));
  }
}
