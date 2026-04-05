import "package:finances/services.dart";
import "package:go_router/go_router.dart";
export "package:go_router/go_router.dart";

import "src/income/onboarding_page.dart";
import "src/expenses/input.dart";
import "src/expenses/page.dart";

/// Contains all the routes for this app.
class Routes {
  /// The route for the home page.
  static const home = "/";
  static const onboarding = "/onboarding";
  static const addExpense = "/expenses/add";
}

/// The router for the app.
final router = GoRouter(
  initialLocation: services.database.needsOnboarding ? Routes.onboarding : Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      name: Routes.home,
      builder: (_, __) => ExpensesPage(),
    ),
    GoRoute(
      path: Routes.onboarding,
      name: Routes.onboarding,
      builder:(context, state) => IncomeOnboardingPage(),
    ),
    GoRoute(
      path: Routes.addExpense,
      name: Routes.addExpense,
      builder:(context, state) => ExpenseInputPage(),
    )
  ],
);
