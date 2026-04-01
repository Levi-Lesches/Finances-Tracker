import "package:finances/services.dart";

import "savings.dart";
import "money.dart";

import "expense.dart";
import "income.dart";
import "payment.dart";

class Budget {
  Income get _income => services.database.income;
  List<Expense> get _expenses => services.database.expenses;
  List<Payment> get payments => services.database.payments;
  List<SavingsGoal> get savingsGoals => services.database.goals;

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
        .where((payment) => payment.expenseID == expense.id)
        .map((payment) => payment.amount)
        .total,
  };

  double estimateMonthsForGoal(SavingsGoal goal) {
    final moneyRemaining = goal.goal - goal.progress;
    return estimatedSavings.inPennies / moneyRemaining.inPennies;
  }
}
