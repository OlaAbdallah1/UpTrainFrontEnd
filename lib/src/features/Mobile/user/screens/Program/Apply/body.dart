import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import '../../../../authentication/models/skills.dart';
import 'application_form.dart';

class Body extends StatelessWidget {
   final String title;
     final int programId;
     final int userId;

final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;
  const Body({
    required this.programId,
    required this.userId,
    required this.title,
    required this.user,
    required this.student,
    required this.skillsO,

  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Application for $title program",
                  style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: tPrimaryColor,fontFamily: 'Ubuntu'),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                 ApplicationForm(skillsO: skillsO , user: user, student: student, programId : programId,userId: userId),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
