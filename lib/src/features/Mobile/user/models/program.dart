import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

import 'company.dart';

class Program {
  late final String title;
  // final String description;
  late final String image;
  late final String start_date;
  final String end_date;
  late final String details;
  late final String trainer;
  late final String company;
    // final Company company;

  late final String branch;

  Program(
      {required this.title,
      required this.image,
      required this.company,
      required this.start_date,
      required this.end_date,
      required this.branch,
      required this.details,
      required this.trainer});

  factory Program.fromJson(json) {
    return Program(
      title: json['pTitle'],
      image: json['cPhoto'],
      // company: Company.fromJson(json['company']),
      company: json['cName'],
      start_date: json['pStart_date'],
      end_date: json['pEnd_date'],
      branch: json['bName'],
      details: json['pDetails'],
      trainer: json['first_name'] + ' ' + json['last_name'],
    );
  }

  // Map<String, dynamic> toJson() => {
  //       'pTitle': title,
  //       'pPhoto': image,
  //       'pStart_date': start_date,
  //       'pEnd_date': end_date,
  //       'bName': branch,
  //       'cName': company,
  //       'tName': trainer,
  //       'pDetails':details
  //     };
  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'start_date': start_date,
        'end_date': end_date,
        'branch': branch,
        'company': company,
        'trainer': trainer,
        'details': details,
      };
}
