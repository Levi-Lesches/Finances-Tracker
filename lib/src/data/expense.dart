import "package:uuid/uuid.dart";

import "money.dart";
import "utils.dart";

enum Interval { daily, monthly, yearly }

class Expense {
  String id = const Uuid().v4();

  Expense({
    required this.name,
    required this.amount,
    required this.interval,
    required this.allAtOnce,
  });
  final String name;
  final Money amount;
  final Interval interval;
  final bool allAtOnce;

  @override
  String toString() => name;

  Money get monthlyAmount => switch (interval) {
    .daily => amount * 30,
    .monthly => amount,
    .yearly => amount.divide(12),
  };

  Expense.fromJson(Json json)
    : name = json["name"],
      amount = Money.fromJson(json["amount"]),
      interval = Interval.values.byName(json["interval"]),
      allAtOnce = json["allAtOnce"],
      id = json["id"];

  Json toJson() => {
    "name": name,
    "amount": amount.toJson(),
    "interval": interval.name,
    "allAtOnce": allAtOnce,
    "id": id,
  };
}

extension ExpensesIterableUtils on Iterable<Expense> {
  Money get monthlyExpenses => map((e) => e.monthlyAmount).total;
}
