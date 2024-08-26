enum Paymenttype {
  cash,
  check,
  bankTransfern,
  postalPayment,
  bankCard,
}

extension PaymenttypeExtension on Paymenttype {
  static Paymenttype fromString(String value) {
    return Paymenttype.values
        .firstWhere((e) => e.toString() == 'Paymenttype.$value');
  }

  String toJson() {
    return toString().split('.').last;
  }
}
