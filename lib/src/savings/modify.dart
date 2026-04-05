import "package:finances/data.dart";
import "package:finances/models.dart";
import "package:finances/pages.dart";
import "package:finances/services.dart";
import "package:finances/view_models.dart";
import "package:finances/widgets.dart";
import "package:flutter/material.dart";

class SavingsEditViewModel extends ViewModel {
  final SavingsGoal? editing;
  SavingsEditViewModel(this.editing) {
    nameController.addListener(notifyListeners);
    goalController.addListener(notifyListeners);
    if (editing != null) {
      nameController.text = editing!.name;
      goalController.text = editing!.goal?.inDollars.toString() ?? "";
    }
  }

  final nameController = TextEditingController();
  final goalController = TextEditingController();

  bool isLimited = true;
  void updateLimit(bool? value) {
    if (value == null) return;
    isLimited = value;
    notifyListeners();
  }

  Future<void> delete() async {
    if (editing == null) return;
    models.budget.deposit(editing!.progress);
    services.database.goals.remove(editing);
    await services.database.save();
  }

  bool get canSave => parse() != null;

  SavingsGoal? parse() {
    final name = nameController.text.nullIfEmpty;
    if (name == null) return null;
    Money? amount;
    if (isLimited) {
      amount = Money.tryParse(goalController.text);
      if (amount == null) return null;
    }
    return SavingsGoal(name: name, goal: amount);
  }

  Future<void> save() async {
    final goal = parse();
    if (goal == null) return;
    services.database.goals.add(goal);
    await services.database.save();
    router.pop();
  }
}

class SavingsEditPage extends ReactiveWidget<SavingsEditViewModel> {
  final SavingsGoal? goal;
  const SavingsEditPage(this.goal);

  @override
  SavingsEditViewModel createModel() => SavingsEditViewModel(goal);

  @override
  Widget build(BuildContext context, SavingsEditViewModel model) => Scaffold(
    appBar: AppBar(title: const Text("Savings Goal Editor")),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: model.nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter a name",
              hintText: "My dream car",
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            title: const Text("I'm saving for a specific amount"),
            subtitle: const Text("Will limit deposits to the given amount if checked"),
            value: model.isLimited,
            onChanged: model.updateLimit,
          ),
          if (model.isLimited) ...[
            const SizedBox(height: 12),
            const Text("Enter an amount to save for"),
            moneyInput(model.goalController),
          ],
          const Spacer(),
          Row(
            children: [
              if (model.editing != null)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Delete"),
                  onPressed: () async {
                    await model.delete();
                    if (!context.mounted) return;
                    context.pop();
                  },
                ),
              const Spacer(),
              TextButton(child: const Text("Cancel"), onPressed: () => context.pop()),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: !model.canSave ? null : () => model.save(),
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
