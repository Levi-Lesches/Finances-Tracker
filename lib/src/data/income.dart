import "money.dart";
import "utils.dart";

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

  Json toJson() => {
    "annualSalary": annualSalary.toJson(),
    "annualTaxes": annualTaxes.toJson(),
  };

  Income.fromJson(Json json) :
    annualSalary = Money.fromJson(json["annualSalary"]),
    annualTaxes = Money.fromJson(json["annualTaxes"]);
}
