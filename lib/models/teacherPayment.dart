enum TeacherpaymentMethod { salary, perHour }

extension TeacherpaymentMethodExtension on TeacherpaymentMethod {
  /// Converts a [String] to a [TeacherpaymentMethod] enum value.
  /// Returns [TeacherpaymentMethod.salary] if the input is unknown or empty.
  static TeacherpaymentMethod fromString(String value) {
    if (value.isEmpty) {
      print('Empty string provided for TeacherpaymentMethod');
      return TeacherpaymentMethod.salary; // Default value
    }

    try {
      return TeacherpaymentMethod.values.firstWhere(
          (e) =>
              e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
          orElse: () {
        print('Unknown TeacherpaymentMethod value: $value');
        return TeacherpaymentMethod.salary; // Default value
      });
    } catch (e) {
      print('Error parsing TeacherpaymentMethod value: $e');
      return TeacherpaymentMethod.salary; // Default value
    }
  }

  /// Converts a [TeacherpaymentMethod] enum value to its corresponding [String] representation.
  String toShortString() {
    return this.toString().split('.').last;
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherPaymentMethod': toShortString(),
    };
  }
}
