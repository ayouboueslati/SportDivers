enum AccountType {
  admin,
  student,
  teacher,
  staff,
}

extension AccountTypeExtension on AccountType {
  String get name {
    switch (this) {
      case AccountType.admin:
        return 'admin';
      case AccountType.student:
        return 'student';
      case AccountType.teacher:
        return 'teacher';
      case AccountType.staff:
        return 'staff';
      default:
        return '';
    }
  }

  static AccountType fromString(String str) {
    switch (str) {
      case 'admin':
        return AccountType.admin;
      case 'student':
        return AccountType.student;
      case 'teacher':
        return AccountType.teacher;
      case 'staff':
        return AccountType.staff;
      default:
        return AccountType.admin; // Default value to handle unexpected strings
    }
  }
}
