import "package:finances/data.dart";
import "package:finances/models.dart";
import "package:finances/pages.dart";
import "package:finances/widgets.dart";
import "package:flutter/material.dart";

import "tile.dart";

class SavingsPage extends ReusableReactiveWidget<Budget> {
  SavingsPage() : super(models.budget);

  Color _getSavingsColor(double x) => switch (x) {
    >= 1 => Colors.green,
    >= 0.5 => Colors.blue,
    >= 0.25 => Colors.orange,
    _ => Colors.red,
  };

  List<Widget> buildCurrentGoal(BuildContext context, Budget model, SavingsGoal goal) => [
    Text(
      "Saving for: ${goal.name} ${goal.isComplete ? '🥳' : ''}",
      style: context.textTheme.headlineMedium,
      textAlign: .center,
    ),
    const SizedBox(height: 12),
    if (goal.goal == null)
      Text(goal.format(), textAlign: .center, style: context.textTheme.titleLarge)
    else
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
                  child: LinearProgressIndicator(
                    value: goal.progressPercent,
                    color: _getSavingsColor(goal.progressPercent),
                  ),
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
    SplitRow(
      title: "Monthly Savings",
      subtitle: "80% after expenses",
      left: Text(
        "Expected savings: \n${model.estimatedSavings.format()}",
        style: context.textTheme.titleLarge?.copyWith(height: 1.5),
        textAlign: .center,
      ),
      right: Text(
        "Savings this month: \n${model.actualSavings.format()}",
        textAlign: .center,
        style: context.textTheme.titleLarge?.copyWith(
          height: 1.5,
          color: _getSavingsColor(model.actualSavings / model.estimatedSavings),
        ),
      ),
    ),
    const SizedBox(height: 12),
    const Divider(),
    SplitRow(
      title: "Make a deposit",
      left: InkCard(
        title: "Deposit Amount",
        subtitle: "Enter an amount to save",
        onTap: () async {
          final amount = await showMoneyDialog(context);
          if (amount == null) return;
          model.save(goal, amount);
        },
      ),
      right: InkCard(
        title: "Leave me with",
        subtitle: "Saves the remainder",
        onTap: () async {
          final amount = await showMoneyDialog(context);
          if (amount == null) return;
          model.save(goal, model.wallet - amount);
        },
      ),
    ),
    const SizedBox(height: 12),
    const Divider(),

    SplitRow(
      title: "Make a withdrawal",
      left: InkCard(
        title: "To Wallet",
        subtitle: "Need the money now?",
        onTap: () async {
          final amount = await showMoneyDialog(context);
          if (amount == null) return;
          model.withdraw(goal, amount);
        },
      ),
      right: InkCard(
        title: "To another goal",
        subtitle: "Re-allocate the funds",
        onTap: model.savingsGoals.length == 1
            ? null
            : () async {
                final amount = await showMoneyDialog(context);
                if (amount == null) return;
                if (!context.mounted) return;
                final otherGoal = await showDialog<SavingsGoal>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    children: [
                      for (final goal in model.savingsGoals.exceptFor(goal))
                        SimpleDialogOption(
                          child: Text(goal.name),
                          onPressed: () => context.pop(goal),
                        ),
                    ],
                  ),
                );
                if (otherGoal == null) return;
                model.transfer(goal, otherGoal, amount);
              },
      ),
    ),
  ];

  @override
  Widget build(BuildContext context, Budget model) => ListView(
    children: [
      if (model.isEditing) ...[
        for (final goal in model.savingsGoals) SavingsTile(goal),
        ListTile(
          title: const Text("New Savings Goal"),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => router.pushNamed(Routes.addSaving),
          ),
        ),
      ] else if (model.chosenGoal == null)
        const Text("Choose a savings goal first", textAlign: .center)
      else
        ...buildCurrentGoal(context, model, model.chosenGoal!),
    ],
  );
}

class InkCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const InkCard({required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Card(
      elevation: onTap == null ? 0 : null,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(title, style: context.textTheme.bodyLarge),
          const SizedBox(height: 24),
          Text(subtitle, style: context.textTheme.bodyMedium?.copyWith(fontStyle: .italic)),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
