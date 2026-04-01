import "money.dart";
import "utils.dart";

class Income {
  final Money annualSalary;
  final Money annualTaxes;
  final DateTime firstPayDay;
  Income({
    required this.annualSalary,
    required this.annualTaxes,
    required this.firstPayDay,
  });

  Money get annualIncome => annualSalary - annualTaxes;
  Money get monthlyIncome => annualIncome / 12;
  Money get paycheck => annualIncome / 26;

  Json toJson() => {
    "annualSalary": annualSalary.toJson(),
    "annualTaxes": annualTaxes.toJson(),
    "firstPayDay": firstPayDay.toIso8601String(),
  };

  Income.fromJson(Json json) :
    annualSalary = Money.fromJson(json["annualSalary"]),
    annualTaxes = Money.fromJson(json["annualTaxes"]),
    firstPayDay = DateTime.parse(json["firstPayDay"]);

  DateTime get nextPayday {
    final now = DateTime.now();
    var date = firstPayDay;
    while (date.isBefore(now)) {
      date = date.add(const Duration(days: 14));
    }
    return date;
  }
}
