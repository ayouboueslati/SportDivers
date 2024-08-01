enum TeacherpaymentMethod {
  salary,
  perHour,
}

extension TeacherpaymentMethodExtension on TeacherpaymentMethod {
  static TeacherpaymentMethod fromString(String value) {
    return TeacherpaymentMethod.values
        .firstWhere((e) => e.toString() == 'TeacherpaymentMethod.$value');
  }
}
