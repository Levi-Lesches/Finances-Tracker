import "money.dart";

class Income {
  final Money annualSalary;
  final Money annualTaxes;
  Income({
    required this.annualSalary,
    required this.annualTaxes,
  });

  Money get annualIncome => annualSalary - annualTaxes;
  Money get monthlyIncome => annualIncome / 12;
  Money get paycheck => annualIncome / 26;
}
