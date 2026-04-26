import "package:finances/services.dart";
import "package:finances/data.dart";
import "package:finances/widgets.dart";

import "model.dart";

class Budget extends DataModel {
  Income get income => services.database.income;
  List<Expense> get allExpenses => services.database.expenses;
  List<SavingsGoal> get savingsGoals => services.database.goals;
  SavingsGoal? get chosenGoal {
    final index = services.settings.goalIndex;
    if (index == -1 || index >= savingsGoals.length) return null;
    return savingsGoals[index];
  }

  @override
  Future<void> init() async {
    services.settings.theme.addListener(notifyListeners);
    _wallet = services.database.wallet;
    _paychecks = services.database.paychecks;
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

  Money _paychecks = Money.zero;
  Money get paychecksRemaining => _paychecks;
  set paychecksRemaining(Money amount) {
    _paychecks = amount;
    services.database.paychecks = amount;
    services.database.save();
  }

  bool isEditing = false;
  void toggleEdit() {
    isEditing = !isEditing;
    notifyListeners();
  }

  // Income page
  Money get paycheck => income.paycheck;
  Money get annualExpenses => allExpenses.annualExpenses;
  Money get netAnnualIncome => income.annualIncome - annualExpenses;
  Money get netMonthlyIncome => netAnnualIncome.divide(12);
  Money get annualSavings => netAnnualIncome * 0.8;
  Money get annualDisposableIncome => netAnnualIncome * 0.2;

  // Expenses page
  Money get estimatedExpenses => allExpenses.monthlyExpenses;
  Money get actualExpenses => allExpenses.totalPaid;
  Money get remainingExpenses => allExpenses.totalRemaining;
  Money get remainingWallet => wallet - remainingExpenses.clamp() + paychecksRemaining;

  // Savings page
  Money get estimatedSavings => (income.monthlyIncome - estimatedExpenses) * 0.8;
  Money get disposableIncome => (income.monthlyIncome - estimatedExpenses) * 0.2;
  Money get actualSavings => ((income.monthlyIncome - actualExpenses) * 0.8).clamp();

  void deposit(Money amount) {
    wallet += amount;
    showSnackBar("Deposited ${amount.format()}");
    notifyListeners();
  }

  void pay(Payment payment) {
    payment.expense.amountPaid += payment.amount;
    wallet -= payment.amount;
    showSnackBar("Paid ${payment.amount.format()} to ${payment.expense}");
    notifyListeners();
  }

  void save(SavingsGoal goal, Money amount) {
    if (amount.isNegative || amount > wallet) {
      return showSnackBar("Not enough money in the wallet to save ${amount.format()}");
    }
    wallet -= amount;
    final leftover = goal.save(amount);
    final actualSaved = amount - leftover;
    wallet += leftover;
    showSnackBar("Saved ${actualSaved.format()} for ${goal.name}");
    notifyListeners();
  }

  void withdraw(SavingsGoal goal, Money amount) {
    if (goal.progress < amount) return showSnackBar("Not enough money saved");
    goal.progress -= amount;
    wallet += amount;
    showSnackBar("Transferred ${amount.format()} back to the wallet");
    notifyListeners();
  }

  void transfer(SavingsGoal from, SavingsGoal to, Money amount) {
    if (from.progress < amount) return showSnackBar("Not enough money saved");
    from.progress -= amount;
    final leftover = to.save(amount);
    final actualAmount = amount - leftover;
    from.progress += leftover;
    showSnackBar("Transferred ${actualAmount.format()} to ${to.name}");
    notifyListeners();
  }

  double estimateMonthsForGoal(SavingsGoal goal) {
    if (goal.goal == null) return 0;
    final moneyRemaining = goal.goal! - goal.progress;
    return moneyRemaining / estimatedSavings;
  }

  DateTime etaForGoal(SavingsGoal goal) {
    final months = estimateMonthsForGoal(goal);
    final days = (30 * months).floor();
    final duration = Duration(days: days);
    return DateTime.now().add(duration);
  }

  void overrideWallet(Money amount) {
    wallet = amount;
    notifyListeners();
  }

  void stopEditing() {
    isEditing = false;
    notifyListeners();
  }

  void rollover(DateTime date) {
    // These lines rely on [allExpenses] being accurate, must run before rolling over
    final entry = HistoryEntry(date: date, expenses: allExpenses, wallet: wallet);
    services.database.history.add(entry);
    if (chosenGoal != null) save(chosenGoal!, actualSavings);

    for (final expense in allExpenses) {
      expense.amountPaid = Money.zero;
    }
    paychecksRemaining = income.monthlyIncome;
    services.database.save();
    stopEditing();
    notifyListeners();
  }

  Future<void> import() async {
    await services.database.import();
    notifyListeners();
    await init();
  }

  void trackGoal(SavingsGoal goal) {
    services.settings.goalIndex = savingsGoals.indexOf(goal);
    services.settings.save();
    stopEditing();
    notifyListeners();
  }

  void depositPaycheck() {
    deposit(paycheck);
    paychecksRemaining = (paychecksRemaining - paycheck).clamp();
  }
}
