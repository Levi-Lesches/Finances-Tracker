import "money.dart";
import "utils.dart";

class Income {
  final Money annualSalary;
  final Money paycheck;
  final DateTime firstPayDay;
  Income({
    required this.annualSalary,
    required this.paycheck,
    required this.firstPayDay,
  });

  Money get annualTaxes => annualSalary - (paycheck * 26);
  Money get annualIncome => paycheck * 26;
  Money get monthlyIncome => annualIncome / 12;

  Json toJson() => {
    "annualSalary": annualSalary.toJson(),
    "paycheck": paycheck.toJson(),
    "firstPayDay": firstPayDay.toIso8601String(),
  };

  Income.fromJson(Json json) :
    annualSalary = Money.fromJson(json["annualSalary"]),
    paycheck = Money.fromJson(json["paycheck"]),
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
