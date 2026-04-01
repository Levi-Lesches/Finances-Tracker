import "money.dart";
import "utils.dart";

class Payment {
  final Money amount;
  final String expenseID;
  const Payment({
    required this.expenseID,
    required this.amount,
  });

  Json toJson() => {
    "amount": amount.toJson(),
    "expenseID": expenseID,
  };

  Payment.fromJson(Json json) :
    amount = Money.fromJson(json["amount"]),
    expenseID = json["expenseID"];
}

extension PaymentIterableUtils on Iterable<Payment> {
  Money get total => map((payment) => payment.amount).total;
}
