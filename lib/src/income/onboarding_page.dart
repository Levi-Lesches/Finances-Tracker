import "package:finances/widgets.dart";
import "package:flutter/material.dart";

import "onboarding_view_model.dart";

class IncomeOnboardingPage extends ReactiveWidget<IncomeOnboardingViewModel>{
  @override
  IncomeOnboardingViewModel createModel() => IncomeOnboardingViewModel();

  @override
  Widget build(BuildContext context, IncomeOnboardingViewModel model) => const Placeholder();
}
