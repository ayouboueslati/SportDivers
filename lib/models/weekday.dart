enum Weekday { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

extension WeekdayExtension on Weekday {
  static Weekday fromString(String value) {
    try {
      return Weekday.values
          .firstWhere((e) => e.toString() == 'Weekday.${value}');
    } catch (e) {
      // Return a default value or handle unknown values
      print('Unknown Weekday value: $value');
      return Weekday.MONDAY; // or any other default value
    }
  }
}
