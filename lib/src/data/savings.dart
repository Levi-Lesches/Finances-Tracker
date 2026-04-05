import "money.dart";
import "utils.dart";

class SavingsGoal {
  final String name;
  final Money goal;
  SavingsGoal({
    required this.name,
    required this.goal,
  });
  Money progress = Money.zero;

  Money save(Money amount) {
    progress += amount;
    if (progress > goal) {
      final leftover = progress - goal;
      progress = goal;
      return leftover;
    } else {
      return Money.zero;
    }
  }

  SavingsGoal.fromJson(Json json) :
    name = json["name"],
    goal = Money.fromJson(json["goal"]);

  Json toJson() => {
    "name": name,
    "goal": goal,
  };
}
