import "package:finances/data.dart";
import "package:finances/pages.dart";
import "package:flutter/material.dart";

class SavingsTile extends StatelessWidget {
  final SavingsGoal goal;
  const SavingsTile(this.goal);

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(goal.name),
    subtitle: Text(goal.format()),
    trailing: IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () => router.pushNamed(Routes.addSaving, extra: goal),
    ),
  );
}
