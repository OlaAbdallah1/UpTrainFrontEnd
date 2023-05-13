import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user_skills.dart';

// import 'package:json_annotation/json_annotation.dart';

// part 'user.g.dart';

// @JsonSerializable()

class User {
  late String email;
  late String password;
  late String firstName;
  late String lastName;
  late String phone;
  late String picture;
  late int field_id;
  late String skills;
  late String field;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.picture,
    required this.field_id,
    required this.field,
  });

  static User fromJson(json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['sPhone_number'],
      picture: json['sPhoto'],
      field_id: json['field_id'],
      email: json['email'],
      field: json['fName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phone': phone,
        'picture': picture,
        'field': field_id,
        'skills': skills
      };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      phone: map['sPhone_number'],
      picture: map['sPhoto'],
      field_id: map['field_id'],
      field: map['fName'],
    );
  }
}
