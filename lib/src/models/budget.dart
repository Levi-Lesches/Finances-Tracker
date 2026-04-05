import "package:finances/services.dart";
import "package:finances/data.dart";

import "model.dart";

class Budget extends DataModel {
  Income get _income => services.database.income;
  List<Expense> get _expenses => services.database.expenses;
  List<Payment> get payments => services.database.payments;
  List<SavingsGoal> get savingsGoals => services.database.goals;

  @override
  Future<void> init() async {}

  Money _wallet = services.database.wallet;
  Money get wallet => _wallet;
  set wallet(Money amount) {
    _wallet = amount;
    services.database.wallet = amount;
    services.database.save();
  }

  Money get estimatedExpenses => _expenses.monthlyExpenses;
  Money get actualExpenses => payments.total;
  Money get remainingExpenses => estimatedExpenses - actualExpenses;

  Money get income => _income.monthlyIncome;
  Money get paycheck => _income.paycheck;
  Money get estimatedSavings => income - estimatedExpenses;
  Money get actualSavings => income - payments.total;

  void deposit(Money amount) {
    wallet += amount;
    notifyListeners();
  }

  void pay(Payment payment) {
    payments.add(payment);
    services.database.save();
    wallet -= payment.amount;
    notifyListeners();
  }

  Money save(SavingsGoal goal, Money amount) {
    // default amount in UI = wallet - remainingExpenses;
    if (amount.isNegative) return Money(0);
    goal.save(amount);
    services.database.save();
    notifyListeners();
    return amount;
  }

  void withdraw(SavingsGoal goal, Money amount) {
    if (goal.progress < amount) throw RangeError("Not enough money saved");
    goal.progress -= amount;
    services.database.save();
    wallet += amount;
    notifyListeners();
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
    return estimatedSavings / moneyRemaining;
  }

  void overrideWallet(Money amount) {
    wallet = amount;
    notifyListeners();
  }

  void addExpense(Expense value) {
    _expenses.add(value);
    services.database.save();
    notifyListeners();
  }
}
