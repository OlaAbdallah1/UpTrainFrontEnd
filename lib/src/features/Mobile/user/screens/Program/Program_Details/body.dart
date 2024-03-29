import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../company/profile/company_profile_screen.dart';
import '../../trainer/profile/trainer_profile_screen.dart';

class Body extends StatelessWidget {
  late final String title;
  late final String image;
  late final String details;
  late final String company;
  late final String startDate;
  late final String endDate;
  Trainer trainer;

  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;
  final List<Skill> programSkills;

  Body(
      {required this.title,
      required this.image,
      required this.details,
      required this.company,
      required this.startDate,
      required this.endDate,
      required this.trainer,
      required this.user,
      required this.student,
      required this.skillsO,
      required this.programSkills});

  @override
  Widget build(BuildContext context) {
    print(trainer.email);
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 75,
                child: Image.asset('assets/images/${image}'),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyAccount(
                                companyName: company,
                                user: user,
                                student: student,
                                skillsO: skillsO,
                              )));
                },
                child: Text(
                  company,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getProportionateScreenHeight(24),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                      color: tPrimaryColor),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Text(
                title,
                style: TextStyle(
                    fontSize: getProportionateScreenHeight(24),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: tPrimaryColor),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text(
                "Program Details: ",
                style: TextStyle(
                    color: tPrimaryColor,
                    fontSize: 20,
                    fontFamily: 'Ubuntu',
                    decoration: TextDecoration.underline),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                details.splitMapJoin('.'),
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(16),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text("Duration",
                  style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      decoration: TextDecoration.underline)),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "$startDate - $endDate",
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(18),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text("Requirments Skills",
                  style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      decoration: TextDecoration.underline)),
              SizedBox(height: getProportionateScreenHeight(10)),
              SizedBox(
                width: getProportionateScreenWidth(200),
                child: Wrap(
                  spacing: 4,
                  children: programSkills
                      .map((skill) => Text(
                            skill.name,
                            style: TextStyle(
                                backgroundColor: Colors.grey[300],
                                color: Colors.black,
                                fontSize: 20),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text("Trainer",
                  style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      decoration: TextDecoration.underline)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrainerAccount(
                                    trainer: trainer,
                                    user: user,
                                    student: student,
                                    skillsO: skillsO,
                                  )));
                    },
                    child: Text(
                      trainer.first_name + ' ' + trainer.last_name,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: getProportionateScreenHeight(18),
                          fontFamily: 'Ubuntu',
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
