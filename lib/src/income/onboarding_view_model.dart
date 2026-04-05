import "package:finances/data.dart";
import "package:finances/pages.dart";
import "package:finances/services.dart";
import "package:finances/view_models.dart";
import "package:flutter/widgets.dart";

class IncomeOnboardingViewModel extends ViewModel {
  final paycheckController = TextEditingController();
  final salaryController = TextEditingController();
  DateTime firstPayDay = DateTime.now();
  String? paycheckError;
  String? salaryError;

  void updatePayDay(DateTime value) {
    firstPayDay = value;
    notifyListeners();
  }

  Future<void> submit() async {
    final paycheck = Money.tryParse(paycheckController.text);
    if (paycheck == null) {
      paycheckError = "Invalid amount";
      notifyListeners();
      return;
    }
    final salary = Money.tryParse(salaryController.text);
    if (salary == null) {
      salaryError = "Invalid amount";
      notifyListeners();
      return;
    }
    services.database.income = Income(
      annualSalary: salary,
      paycheck: paycheck,
      firstPayDay: firstPayDay,
    );
    await services.database.save();
    router.go(Routes.home);
  }
}
