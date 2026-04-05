import "package:finances/services.dart";
import "package:finances/data.dart";

import "model.dart";

class Budget extends DataModel {
  Income get income => services.database.income;
  List<Expense> get _expenses => services.database.expenses;
  List<SavingsGoal> get savingsGoals => services.database.goals;
  // List<SavingsGoal> get savingsGoals => [
  // SavingsGoal(goal: Money.fromDollars(15_000), name: "New Car")
  //   ..progress = Money.fromDollars(8_000),
  // ];

  @override
  Future<void> init() async {
    services.settings.theme.addListener(notifyListeners);
    _wallet = services.database.wallet;
  }

  @override
  void dispose() {
    services.settings.theme.removeListener(notifyListeners);
    super.dispose();
  }

  Money _wallet = Money.zero;
  Money get wallet => _wallet;
  set wallet(Money amount) {
    _wallet = amount;
    services.database.wallet = amount;
    services.database.save();
  }

  bool isEditing = false;
  void toggleEdit() {
    isEditing = !isEditing;
    notifyListeners();
  }

  // Income page
  Money get paycheck => income.paycheck;
  Money get annualExpenses => _expenses.annualExpenses;
  Money get netAnnualIncome => income.annualIncome - annualExpenses;
  Money get netMonthlyIncome => netAnnualIncome.divide(12);

  // Expenses page
  Money get estimatedExpenses => _expenses.monthlyExpenses;
  Money get actualExpenses => _expenses.totalPaid;
  Money get remainingExpenses => _expenses.totalRemaining;
  Money get remainingWallet => wallet - remainingExpenses.clamp();

  // Savings page
  Money get estimatedSavings => (income.monthlyIncome - estimatedExpenses) * 0.8;
  Money get actualSavings => ((income.monthlyIncome - _expenses.totalPaid) * 0.8).clamp();

  void deposit(Money amount) {
    wallet += amount;
    notifyListeners();
  }

  void pay(Payment payment) {
    payment.expense.amountPaid += payment.amount;
    wallet -= payment.amount;
    notifyListeners();
  }

  Money save(SavingsGoal goal, Money amount) {
    // default amount in UI = wallet - remainingExpenses;
    if (amount.isNegative) return Money.zero;
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
    for (final expense in _expenses) expense: expense.amountPaid,
  };

  double estimateMonthsForGoal(SavingsGoal goal) {
    if (goal.goal == null) return 0;
    final moneyRemaining = goal.goal! - goal.progress;
    return estimatedSavings / moneyRemaining;
  }

  void overrideWallet(Money amount) {
    wallet = amount;
    notifyListeners();
  }

  void stopEditing() {
    isEditing = false;
    notifyListeners();
  }

  void rollover() {
    for (final expense in _expenses) {
      expense.amountPaid = Money.zero;
    }
    services.database.save();
    stopEditing();
    notifyListeners();
  }

  Future<void> import() async {
    await services.database.import();
    notifyListeners();
    await init();
  }
}
