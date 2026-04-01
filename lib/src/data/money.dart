import "package:collection/collection.dart";

extension type Money (int inPennies) {
  Money operator * (int n) => Money(inPennies * n);
  Money operator / (int n) => Money(inPennies ~/ n);
  Money operator + (Money other) => Money(inPennies + other.inPennies);
  Money operator - (Money other) => Money(inPennies - other.inPennies);
  bool operator < (Money other) => inPennies < other.inPennies;
  bool operator > (Money other) => inPennies > other.inPennies;

  String format() => "\$${inPennies / 100}";

  bool get isPositive => inPennies >= 0;
  bool get isNegative => inPennies < 0;
}

extension ListMoneyUtils on Iterable<Money> {
  Money get total => Money(map((m) => m.inPennies).sum);
}
