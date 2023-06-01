import 'dart:io';

import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';

class Application {
  String cv;
  int id;
  int status;
  int user_id;
  int program_id;
  String program_name;
  User user;
  Application(
      {required this.cv,
      required this.id,
      required this.status,
      required this.user,
      required this.user_id,
      required this.program_name,
      required this.program_id});

  static Application fromJson(json) => Application(
        cv: json['cv'],
        id: json['id'],
        status: json['status'],
        user: User.fromJson(json),
        user_id: json['student_id'],
        program_id: json['program_id'],
        program_name: json['pTitle'],
      );
}
