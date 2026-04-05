import "package:finances/data.dart";
import "package:finances/models.dart";
import "package:finances/pages.dart";
import "package:flutter/material.dart";

class SavingsTile extends StatelessWidget {
  final SavingsGoal goal;
  const SavingsTile(this.goal);

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(goal.name),
    subtitle: Text(goal.format()),
    leading: IconButton(
      icon: models.budget.chosenGoal == goal
          ? const Icon(Icons.star)
          : const Icon(Icons.star_outline),
      color: Colors.orange,
      onPressed: () => models.budget.trackGoal(goal),
    ),
    trailing: IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () => router.pushNamed(Routes.addSaving, extra: goal),
    ),
  );
}
