import "money.dart";
import "utils.dart";

class SavingsGoal {
  String name;
  Money? goal;
  SavingsGoal({required this.name, required this.goal});

  Money progress = Money.zero;
  Money get amountRemaining => goal! - progress;

  String format() =>
      goal == null ? "${progress.format()} so far" : "${progress.format()} / ${goal!.format()}";

  Money save(Money amount) {
    progress += amount;
    final goal = this.goal;
    if (goal != null && progress > goal) {
      final leftover = progress - goal;
      progress = goal;
      return leftover;
    } else {
      return Money.zero;
    }
  }

  SavingsGoal.fromJson(Json json) : name = json["name"], goal = json.maybe("goal", Money.fromJson);

  double get progressPercent => goal == null ? 0 : (progress / goal!);

  bool get isComplete => goal != null && progress == goal;

  Json toJson() => {"name": name, "goal": goal};
}
