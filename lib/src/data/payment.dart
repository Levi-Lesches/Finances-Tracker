import "expense.dart";
import "money.dart";

class Payment {
  final Money amount;
  final Expense expense;
  const Payment({
    required this.expense,
    required this.amount,
  });
}
