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
    this.amountPaid = Money.zero,
  });

  String name;
  Money amount;
  Money amountPaid;
  Interval interval;
  bool allAtOnce;

  @override
  String toString() => name;

  Money get monthlyAmount => switch (interval) {
    .daily => amount * 30,
    .monthly => amount,
    .yearly => amount.divide(12),
  };

  Money get annualAmount => monthlyAmount * 12;

  Money get monthlyAmountRemaining => (monthlyAmount - amountPaid).clamp();

  Expense.fromJson(Json json)
    : name = json["name"],
      amount = Money.fromJson(json["amount"]),
      amountPaid = Money.fromJson(json["currentSpending"]),
      interval = Interval.values.byName(json["interval"]),
      allAtOnce = json["allAtOnce"],
      id = json["id"];

  Json toJson() => {
    "name": name,
    "amount": amount.toJson(),
    "currentSpending": amountPaid.toJson(),
    "interval": interval.name,
    "allAtOnce": allAtOnce,
    "id": id,
  };
}

extension ExpensesIterableUtils on Iterable<Expense> {
  Money get monthlyExpenses => map((e) => e.monthlyAmount).total;
  Money get annualExpenses => map((e) => e.annualAmount).total;
  Money get totalPaid => map((e) => e.amountPaid).total;
  Money get totalRemaining => map((e) => e.monthlyAmountRemaining).total;
}
