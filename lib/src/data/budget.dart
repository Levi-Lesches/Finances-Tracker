import "savings.dart";
import "money.dart";

import "expenses.dart";
import "income.dart";

class Payment {
  final Money amount;
  final Expense expense;
  const Payment({
    required this.expense,
    required this.amount,
  });
}

extension PaymentIterableUtils on Iterable<Payment> {
  Money get total => map((payment) => payment.amount).total;
}

class Budget {
  final Income _income;
  final List<Expense> _expenses;
  final List<Payment> payments = [];
  final List<SavingsGoal> savingsGoals = [];
  Budget(this._expenses, this._income);

  Money wallet = Money(0);

  Money get estimatedExpenses => _expenses.monthlyExpenses;
  Money get actualExpenses => payments.total;
  Money get remainingExpenses => estimatedExpenses - actualExpenses;

  Money get income => _income.monthlyIncome;
  Money get paycheck => _income.paycheck;
  Money get estimatedSavings => income - estimatedExpenses;
  Money get actualSavings => income - payments.total;

  void deposit(Money amount) => wallet += amount;

  void pay(Payment payment) {
    payments.add(payment);
    wallet -= payment.amount;
  }

  Money save(SavingsGoal goal, Money amount) {
    // default amount in UI = wallet - remainingExpenses;
    if (amount.isNegative) return Money(0);
    goal.save(amount);
    return amount;
  }

  void withdraw(SavingsGoal goal, Money amount) {
    if (goal.progress < amount) throw RangeError("Not enough money saved");
    goal.progress -= amount;
    wallet += amount;
  }

  Map<Expense, Money> get budgetBreakdown => {
    for (final expense in _expenses)
      expense: payments
        .where((payment) => payment.expense == expense)
        .map((payment) => payment.amount)
        .total,
  };

  double estimateMonthsForGoal(SavingsGoal goal) {
    final moneyRemaining = goal.goal - goal.progress;
    return estimatedSavings.inPennies / moneyRemaining.inPennies;
  }


}
