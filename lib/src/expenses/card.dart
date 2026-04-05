import "package:finances/data.dart";
import "package:finances/widgets.dart";
import "package:flutter/material.dart";

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final Money currentSpending;
  final ValueChanged<Payment> makePayment;
  const ExpenseCard({
    required this.expense,
    required this.currentSpending,
    required this.makePayment,
  });

  Payment _pay(Money amount) => Payment(amount: amount, expenseID: expense.id);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () async {
      if (expense.allAtOnce) {
        makePayment(_pay(expense.amount));
      } else {
        final amount = await showMoneyDialog(context);
        if (amount == null) return;
        makePayment(_pay(amount));
      }
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Column(
          children: [
            Text(expense.name, style: context.textTheme.titleLarge),
            const Text("Tap to pay", style: TextStyle(fontStyle: .italic)),
            const SizedBox(height: 24),
            Text("${currentSpending.format()} / ${expense.monthlyAmount.format()}"),
            LinearProgressIndicator(value: currentSpending / expense.monthlyAmount),
          ],
        ),
      ),
    ),
  );
}
