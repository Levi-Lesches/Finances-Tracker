import "package:finances/data.dart";
import "package:finances/models.dart";
import "package:finances/widgets.dart";
import "package:flutter/material.dart";

import "tile.dart";

class SavingsPage extends ReusableReactiveWidget<Budget> {
  SavingsPage() : super(models.budget);

  List<Widget> buildCurrentGoal(BuildContext context, Budget model, SavingsGoal goal) => [
    Text("Saving for: ${goal.name}", style: context.textTheme.headlineMedium, textAlign: .center),
    // const SizedBox(height: 8),
    // Text(goal.name, style: context.textTheme.titleLarge, textAlign: .center),
    const SizedBox(height: 12),
    if (goal.goal != null)
      Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Progress:", style: context.textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(goal.format()),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LinearProgressIndicator(value: goal.progressPercent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 72, child: VerticalDivider()),
          Expanded(
            child: Column(
              children: [
                Text("Time to save:", style: context.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  "${model.estimateMonthsForGoal(goal).ceil()} month(s)",
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    const SizedBox(height: 12),
    const Divider(),
    const SizedBox(height: 12),
  ];

  @override
  Widget build(BuildContext context, Budget model) => Column(
    children: [
      if (model.savingsGoals.isEmpty)
        const Text("No savings goals yet")
      else
        ...buildCurrentGoal(context, model, model.savingsGoals.first),

      Row(
        spacing: 8,
        mainAxisAlignment: .center,
        children: [
          Text(
            "Expected savings: \n${model.estimatedSavings.format()}",
            style: context.textTheme.titleLarge?.copyWith(height: 1.5),
            textAlign: .center,
          ),
          const SizedBox(height: 36, child: VerticalDivider()),
          Text(
            "Savings so far: \n${model.actualSavings.format()}",
            style: context.textTheme.titleLarge?.copyWith(height: 1.5),
            textAlign: .center,
          ),
        ],
      ),

      const SizedBox(height: 32),
      if (model.savingsGoals.length < 2) const Text("No other savings goals"),
      for (final goal in model.savingsGoals.sublist(1)) SavingsTile(goal),
    ],
  );
}
