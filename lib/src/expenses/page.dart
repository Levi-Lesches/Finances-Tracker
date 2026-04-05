import "package:finances/data.dart";
import "package:finances/pages.dart";
import "package:flutter/material.dart";

import "package:finances/models.dart";
import "package:finances/widgets.dart";

import "card.dart";

class ExpensesPage extends ReusableReactiveWidget<Budget> {
  ExpensesPage() : super(models.budget);

  @override
  Widget build(BuildContext context, Budget model) => Scaffold(
    appBar: AppBar(title: const Text("Expenses")),
    // floatingActionButton: FloatingActionButton(
    //   child: const Icon(Icons.wallet),
    //   onPressed: () => model.deposit(model.paycheck),
    // ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => router.pushNamed(Routes.addExpense),
    ),
    body: Center(
      child: Column(
        children: [
          Text("Wallet", style: context.textTheme.headlineLarge),
          Row(
            mainAxisAlignment: .center,
            children: [
              Text(model.wallet.format(), style: context.textTheme.displayLarge),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.edit),
                iconSize: 32,
                onPressed: () async {
                  final result = await showMoneyDialog(context);
                  if (result == null) return;
                  model.overrideWallet(result);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2,
              children: [
                for (final (expense, amount) in model.budgetBreakdown.records)
                  ExpenseCard(
                    expense: expense,
                    currentSpending: amount,
                    makePayment: model.pay,
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
