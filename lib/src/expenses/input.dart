import "package:finances/data.dart";
import "package:finances/pages.dart";
import "package:finances/services.dart";
import "package:finances/view_models.dart";
import "package:finances/widgets.dart";
import "package:flutter/material.dart" hide Interval;

class ExpenseInputViewModel extends ViewModel {
  Expense? editing;
  ExpenseInputViewModel([this.editing]) {
    if (editing != null) {
      nameController.text = editing!.name;
      moneyController.text = editing!.amount.inDollars.toString();
      interval = editing!.interval;
      isLumpSum = editing!.allAtOnce;
    }
  }

  final nameController = TextEditingController();
  final moneyController = TextEditingController();
  Interval interval = .monthly;
  void updateInterval(Interval? value) {
    if (value == null) return;
    interval = value;
    notifyListeners();
  }

  bool isLumpSum = false;
  void updateLumpSum(bool? value) {
    if (value == null) return;
    isLumpSum = value;
    notifyListeners();
  }

  void save() {
    final amount = Money.tryParse(moneyController.text);
    final name = nameController.text.nullIfEmpty;
    if (name == null) {
      errorText = "Name cannot be blank";
      notifyListeners();
      return;
    } else if (amount == null) {
      errorText = "Invalid money amount";
      notifyListeners();
      return;
    }
    if (editing != null) {
      editing!.allAtOnce = isLumpSum;
      editing!.amount = amount;
      editing!.interval = interval;
      editing!.name = name;
      services.database.save();
      router.pop();
    } else {
      final expense = Expense(allAtOnce: isLumpSum, amount: amount, interval: interval, name: name);
      services.database.expenses.add(expense);
      services.database.save();
      router.pop();
    }
  }
}

class ExpenseInputPage extends ReactiveWidget<ExpenseInputViewModel> {
  final Expense? expense;
  const ExpenseInputPage(this.expense);

  @override
  ExpenseInputViewModel createModel() => ExpenseInputViewModel(expense);

  @override
  Widget build(BuildContext context, ExpenseInputViewModel model) => Scaffold(
    appBar: AppBar(title: const Text("New Expense")),
    body: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const .all(12),
              children: [
                const Text("Enter a name"),
                TextField(controller: model.nameController),
                const Text("Enter an amount"),
                moneyInput(model.moneyController),
                const Text("How often is this expense?"),
                DropdownButton<Interval>(
                  value: model.interval,
                  onChanged: model.updateInterval,
                  items: [
                    for (final interval in Interval.values)
                      DropdownMenuItem(value: interval, child: Text(interval.name)),
                  ],
                ),
                CheckboxListTile(
                  title: const Text("This expense is a lump sum"),
                  subtitle: const Text("Check this box to pay the whole amount at once"),
                  onChanged: model.updateLumpSum,
                  value: model.isLumpSum,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: .end,
            children: [
              TextButton(child: const Text("Cancel"), onPressed: () => context.pop()),
              const SizedBox(width: 12),
              FilledButton(child: const Text("Save"), onPressed: () => model.save()),
            ],
          ),
        ],
      ),
    ),
  );
}
