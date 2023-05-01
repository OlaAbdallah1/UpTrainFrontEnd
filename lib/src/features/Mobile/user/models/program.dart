import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

class Program {
  late final String title;
  final String description;
  late final String image;
  late final String company;
  late final String branch;
  late final String start_date;
  final String end_date;
  late final String details;
 late final String trainer;


  Program(
      {required this.title,
      required this.description,
      required this.image,
      required this.company,
      required this.start_date,
      required this.end_date,
      required this.branch,
      required this.details,
      required this.trainer});

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      company: json['company'],
      start_date: json['start_date'],
      end_date: json['end_date'],
      branch: json['branch'],
      details: json['details'],
      trainer: json['trainer'],
    );
  }

    Map<String, dynamic> toJson() => {
       'title':title,
       'description':description,
       'image':image,
       'company':company,
       'start_date':start_date,
       'end_date':end_date,
       'branch':branch,
       'details':details,
       'trainer':trainer
      };
}
