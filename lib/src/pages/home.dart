import "package:finances/models.dart";
import "package:finances/pages.dart";
import "package:finances/services.dart";
import "package:flutter/material.dart";

import "package:finances/widgets.dart";

final routes = [Routes.income, Routes.expenses, Routes.savings];

final fabs = <Widget? Function(Budget)>[
  (Budget model) => FloatingActionButton(
    tooltip: "Add paycheck",
    child: const Icon(Icons.credit_score),
    onPressed: () => model.deposit(model.paycheck),
  ),
  (Budget model) => null,
  (Budget model) => null,
];

/// The home page.
class HomePage extends ReusableReactiveWidget<Budget> {
  final Widget child;
  HomePage(this.child) : super(models.budget);

  int get routeIndex {
    final name = "/${router.state.uri.pathSegments.first}";
    return routes.indexOf(name);
  }

  @override
  Widget build(BuildContext context, Budget model) => Scaffold(
    appBar: AppBar(
      title: const Text("My Finances"),
      actions: [
        IconButton(icon: const Icon(Icons.file_open), onPressed: model.import),
        IconButton(icon: const Icon(Icons.save), onPressed: services.database.export),
        IconButton(icon: const Icon(Icons.edit), onPressed: model.toggleEdit),
      ],
    ),
    floatingActionButton: fabs[routeIndex](model),
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
            child: Padding(padding: const EdgeInsets.all(8), child: child),
          ),
        ],
      ),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: routeIndex,
      onDestinationSelected: (index) => router.go(routes[index]),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.attach_money), label: "Income"),
        NavigationDestination(icon: Icon(Icons.shopping_cart), label: "Expenses"),
        NavigationDestination(icon: Icon(Icons.savings), label: "Savings"),
      ],
    ),
  );
}
