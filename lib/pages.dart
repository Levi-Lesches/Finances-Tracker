import "package:finances/data.dart";
import "package:finances/services.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
export "package:go_router/go_router.dart";

import "src/pages/home.dart";
import "src/pages/savings.dart";
import "src/income/onboarding_page.dart";
import "src/income/page.dart";
import "src/expenses/input.dart";
import "src/expenses/page.dart";

/// Contains all the routes for this app.
class Routes {
  /// The route for the home page.
  static const home = "/";
  static const onboarding = "/onboarding";
  static const addExpense = "/expenses/add";
  static const expenses = "/expenses";
  static const income = "/income";
  static const savings = "/savings";
}

Future<void> _import() async {
  await services.database.import();
  router.go(Routes.home);
}

/// The router for the app.
final router = GoRouter(
  initialLocation: services.database.needsOnboarding ? Routes.onboarding : Routes.expenses,
  routes: [
    GoRoute(
      path: Routes.onboarding,
      name: Routes.onboarding,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          actions: const [IconButton(icon: Icon(Icons.file_open), onPressed: _import)],
        ),
        body: IncomeOnboardingPage(),
      ),
    ),
    GoRoute(
      path: Routes.home,
      redirect: (_, _) => services.database.needsOnboarding ? Routes.onboarding : Routes.expenses,
    ),
    GoRoute(
      path: Routes.addExpense,
      name: Routes.addExpense,
      builder: (context, state) => ExpenseInputPage(state.extra as Expense?),
    ),
    ShellRoute(
      pageBuilder: (context, state, child) => NoTransitionPage(child: HomePage(child)),
      routes: [
        GoRoute(
          path: Routes.income,
          name: Routes.income,
          builder: (context, state) => IncomePage(),
        ),
        GoRoute(
          path: Routes.expenses,
          name: Routes.expenses,
          builder: (context, state) => ExpensesPage(),
        ),
        GoRoute(
          path: Routes.savings,
          name: Routes.savings,
          builder: (context, state) => SavingsPage(),
        ),
      ],
    ),
  ],
);
