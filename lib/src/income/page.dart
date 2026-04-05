import "package:finances/models.dart";
import "package:finances/widgets.dart";
import "package:flutter/material.dart";

import "onboarding_page.dart";

class IncomePage extends ReusableReactiveWidget<Budget> {
  IncomePage() : super(models.budget);

  @override
  Widget build(BuildContext context, Budget model) => model.isEditing
      ? IncomeOnboardingPage()
      : Center(
          child: ListTileTheme(
            data: ListTileThemeData(
              leadingAndTrailingTextStyle: context.textTheme.bodyLarge,
              minVerticalPadding: 0,
              minTileHeight: 28,
            ),
            child: Column(
              children: [
                Text("Next Paycheck: ", style: context.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    Text(
                      context.formatDate(model.income.nextPayday),
                      style: context.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 36, child: VerticalDivider()),
                    Text(model.income.paycheck.format(), style: context.textTheme.headlineLarge),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text("Annual Salary"),
                  trailing: Text(model.income.annualSalary.format()),
                ),
                ListTile(
                  title: const Text("Taxes"),
                  trailing: Text(model.income.annualTaxes.format()),
                ),
                ListTile(
                  title: const Text("Annual Expenses"),
                  trailing: Text(model.annualExpenses.format()),
                ),
                ListTile(
                  title: const Text("Net Income"),
                  trailing: Text(model.netAnnualIncome.format()),
                ),
                ListTile(
                  title: const Text("Net Monthly Income"),
                  trailing: Text(model.netMonthlyIncome.format()),
                ),
              ],
            ),
          ),
        );
}
