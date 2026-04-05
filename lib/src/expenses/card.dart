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

  Payment _pay(Money amount) => Payment(amount: amount, expense: expense);

  Future<void> tapToPay(BuildContext context, {bool isPayment = true}) async {
    final factor = isPayment ? 1 : -1;
    if (expense.allAtOnce) {
      makePayment(_pay(expense.amount * factor));
    } else {
      final amount = await showMoneyDialog(context);
      if (amount == null) return;
      makePayment(_pay(amount * factor));
    }
  }

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => tapToPay(context),
    onLongPress: () => tapToPay(context, isPayment: false),
    onSecondaryTap: () => tapToPay(context, isPayment: false),
    child: Card(
      color: expense.amountPaid > expense.amount ? Colors.red.shade300 : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Column(
          children: [
            Text(expense.name, style: context.textTheme.titleLarge),
            const Text("Tap to pay", style: TextStyle(fontStyle: .italic)),
            const Text("Hold to un-spend", style: TextStyle(fontStyle: .italic)),
            const Spacer(),
            Text("${currentSpending.format()} / ${expense.monthlyAmount.format()}"),
            LinearProgressIndicator(value: currentSpending / expense.monthlyAmount),
          ],
        ),
      ),
    ),
  );
}
