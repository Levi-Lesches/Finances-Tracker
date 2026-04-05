import "package:finances/data.dart";
import "package:flutter/material.dart";

class SavingsTile extends StatelessWidget {
  final SavingsGoal goal;
  const SavingsTile(this.goal);

  @override
  Widget build(BuildContext context) =>
      ListTile(title: Text(goal.name), subtitle: Text(goal.format()));
}
