import "package:finances/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "onboarding_view_model.dart";

class IncomeOnboardingPage extends ReactiveWidget<IncomeOnboardingViewModel>{
  @override
  IncomeOnboardingViewModel createModel() => IncomeOnboardingViewModel();

  @override
  Widget build(BuildContext context, IncomeOnboardingViewModel model) => Scaffold(
    appBar: AppBar(title: const Text("Onboarding")),
    body: Center(
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text("Fill in your income info below", style: context.textTheme.headlineLarge,),
            const Divider(),
            const SizedBox(height: 24),
            const ListTile(
              leading: CircleAvatar(child: Text("1")),
              title: Text("How much is your bi-weekly paycheck?"),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: model.paycheckController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(prefixIcon: Icon(Icons.attach_money)),
              ),
            ),
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
              title:Text("How much is your total salary?"),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: model.salaryController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(prefixIcon: Icon(Icons.attach_money)),
              ),
            ),
            const SizedBox(height: 48),
            FilledButton(
              child: const Text("Submit"),
              onPressed: () => model.submit(),
            ),
          ],
        ),
      ),
    )
  );
}
