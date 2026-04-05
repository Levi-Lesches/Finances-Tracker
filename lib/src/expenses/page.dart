import "package:finances/data.dart";
import "package:finances/pages.dart";
import "package:flutter/material.dart";

import "package:finances/models.dart";
import "package:finances/widgets.dart";

import "card.dart";

class ExpensesPage extends ReusableReactiveWidget<Budget> {
  ExpensesPage() : super(models.budget);

  @override
  Widget build(BuildContext context, Budget model) => ListView(
    padding: const .symmetric(horizontal: 4),
    children: [
      Text(
        "Expect to spend: ${model.remainingExpenses.format()}",
        style: context.textTheme.titleLarge,
        textAlign: .center,
      ),
      const SizedBox(height: 12),
      Text(
        "${model.actualExpenses.format()} / ${model.estimatedExpenses.format()}",
        textAlign: .center,
      ),
      LinearProgressIndicator(value: model.actualExpenses / model.estimatedExpenses),
      const SizedBox(height: 12),
      if (model.isEditing) ...[
        for (final expense in model.budgetBreakdown.keys)
          ListTile(
            title: Text(expense.name),
            subtitle: Text(expense.amount.format()),
            trailing: IconButton(
              onPressed: () => router.pushNamed(Routes.addExpense, extra: expense),
              icon: const Icon(Icons.edit),
            ),
          ),
        ListTile(
          title: const Text("Add new expense"),
          trailing: IconButton(
            onPressed: () => router.pushNamed(Routes.addExpense),
            icon: const Icon(Icons.add),
          ),
        ),
        FilledButton(onPressed: model.rollover, child: const Text("Rollover")),
      ] else
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.75,
          children: [
            for (final (expense, amount) in model.budgetBreakdown.records)
              ExpenseCard(expense: expense, currentSpending: amount, makePayment: model.pay),
          ],
        ),
    ],
  );
}
