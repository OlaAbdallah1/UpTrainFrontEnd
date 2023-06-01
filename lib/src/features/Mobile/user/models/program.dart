import 'package:uptrain/src/features/Mobile/user/models/branch.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

import 'company.dart';

class Program {
  int id;
  // final int user_id;
  late String title;
  late String image;
  late String start_date;
  final String end_date;
  late String details;
  // late final String trainer;
  late Trainer trainer;
  late String company;
  late Branch branch;

  Program(
      {required this.id,
      // required this.user_id,
      required this.title,
      required this.image,
      required this.company,
      required this.start_date,
      required this.end_date,
      required this.branch,
      required this.details,
      required this.trainer});

  factory Program.fromJson(json) {
    return Program(
        id: json['id'].toInt(),
        // user_id: json['user_id'],
        title: json['pTitle'],
        image: json['cPhoto'],
        company: json['cName'],
        start_date: json['pStart_date'],
        end_date: json['pEnd_date'],
        branch: Branch.fromJson(json),
        details: json['pDetails'],
        trainer: Trainer.fromJson(json));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        // 'user_id': user_id,
        'title': title,
        'image': image,
        'start_date': start_date,
        'end_date': end_date,
        'branch': branch,
        'company': company,
        // 'trainer': trainer,
        'details': details,
      };
}
