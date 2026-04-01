import "money.dart";

enum Interval {
  daily,
  monthly,
  yearly,
}

class Expense {
  Expense(this.name, this.amount, this.startDate, this.interval, {required this.allAtOnce});
  final String name;
  final Money amount;
  final Interval interval;
  final DateTime startDate;
  final bool allAtOnce;

  @override
  String toString() => name;

  Money get monthlyAmount => switch (interval) {
    .daily => amount * 30,
    .monthly => amount,
    .yearly => amount / 12,
  };
}

extension ExpensesIterableUtils on Iterable<Expense> {
  Money get monthlyExpenses => map((e) => e.monthlyAmount).total;
}
