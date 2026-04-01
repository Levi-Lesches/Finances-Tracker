import "money.dart";

class SavingsGoal {
  final String name;
  final Money goal;
  SavingsGoal({
    required this.name,
    required this.goal,
  });
  Money progress = Money(0);

  Money save(Money amount) {
    progress += amount;
    if (progress > goal) {
      final leftover = progress - goal;
      progress = goal;
      return leftover;
    } else {
      return Money(0);
    }
  }
}
