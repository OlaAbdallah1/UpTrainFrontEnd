import 'dart:io';

import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';

class Task {
  int id;
  final String title;
  final String description;
  final int program_id;
  final String deadline;
  final String program_name;
  final int status;
  final int trainer_id;
  final String trainer_name;
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.program_id,
    required this.program_name,
    required this.status,
    required this.trainer_id,
    required this.trainer_name
  });

  static Task fromJson(json) => Task(
        id: json['id'].toInt(),
        title: json['taTitle'],
        description: json['taDescription'],
        deadline: json['taDeadline'],
        program_id: json['program_id'],
        program_name: json['pTitle'],
        status: json['taStatus'],
        trainer_id: json['trainer_id'],
        trainer_name: json['first_name']+' '+json['last_name'],
      );
}
