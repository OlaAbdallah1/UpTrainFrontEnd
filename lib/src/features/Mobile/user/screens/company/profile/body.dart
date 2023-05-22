import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';

import '../../../../authentication/models/skills.dart';
import 'company_details.dart';
import 'company_programs.dart';

class Body extends StatelessWidget {
  final String companyName;
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;

  Body(
      {required this.companyName,
      required this.user,
      required this.student,
      required this.skillsO});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          CompanyDetails(companyName: companyName),
          SizedBox(height: getProportionateScreenHeight(10)),
          Text(
            "Trainings Provided by $companyName:",
            style: TextStyle(
                fontSize: getProportionateScreenHeight(22),
                decoration: TextDecoration.underline,
                fontFamily: 'Ubuntu',
                color: tPrimaryColor),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          CompanyPrograms(companyName: companyName,user: user, student: student, skillsO: skillsO,)
        ],
      ),
    );
  }
}
