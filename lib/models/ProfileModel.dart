import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String cin;
  final String email;
  final String accountType;
  final bool isActive;
  final DateTime createdAt;
  final Profile profile;

  User({
    required this.id,
    required this.cin,
    required this.email,
    required this.accountType,
    required this.isActive,
    required this.createdAt,
    required this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      cin: json['cin'],
      email: json['email'],
      accountType: json['accountType'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      profile: Profile.fromJson(json['profile']),
    );
  }
}

class Profile {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final DateTime birthdate;
  final String address;
  final String gender;
  final DateTime inscriptionDate;
  final String profilePicture;
  final String paymentMethod;
  final String discountType;
  final int discount;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthdate,
    required this.address,
    required this.gender,
    required this.inscriptionDate,
    required this.profilePicture,
    required this.paymentMethod,
    required this.discountType,
    required this.discount,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      birthdate: DateTime.parse(json['birthdate']),
      address: json['address'],
      gender: json['gender'],
      inscriptionDate: DateTime.parse(json['inscriptionDate']),
      profilePicture: json['profilePicture'],
      paymentMethod: json['paymentMethod'],
      discountType: json['discountType'],
      discount: json['discount'],
    );
  }
}