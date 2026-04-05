import "package:finances/widgets.dart";
import "package:flutter/material.dart";

import "onboarding_view_model.dart";

class IncomeOnboardingPage extends ReactiveWidget<IncomeOnboardingViewModel> {
  @override
  IncomeOnboardingViewModel createModel() => IncomeOnboardingViewModel();

  @override
  Widget build(BuildContext context, IncomeOnboardingViewModel model) => Center(
    child: SizedBox(
      width: 500,
      child: ListView(
        children: [
          Text(
            "Fill in your income info",
            style: context.textTheme.headlineLarge,
            textAlign: .center,
          ),
          const Divider(),
          const SizedBox(height: 24),
          const ListTile(
            leading: CircleAvatar(child: Text("1")),
            title: Text("How much is your bi-weekly paycheck?"),
          ),
          moneyInput(model.paycheckController),
          const SizedBox(height: 24),
          const ListTile(
            leading: CircleAvatar(child: Text("2")),
            title: Text("When is your next paycheck?"),
          ),
          TextButton(
            child: Text(context.formatDate(model.firstPayDay)),
            onPressed: () async {
              final result = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (result == null) return;
              model.updatePayDay(result);
            },
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: CircleAvatar(child: Text("3")),
            title: Text("How much is your total salary?"),
          ),
          moneyInput(model.salaryController),
          const SizedBox(height: 48),
          FilledButton(child: const Text("Submit"), onPressed: () => model.submit()),
        ],
      ),
    ),
  );
}
