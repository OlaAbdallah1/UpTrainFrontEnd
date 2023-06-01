import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Mobile/user/screens/trainer/trainer_programs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../authentication/models/skills.dart';
import 'trainer_profile_details.dart';

class Body extends StatelessWidget {
  final Trainer trainer;
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;
  Body(
      {required this.trainer,
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
          SizedBox(height: getProportionateScreenHeight(20)),
          TrainerDetails(
            trainer: trainer,
            user: user,
            student: student,
            skillsO: skillsO,
          ),
         
          // TrainerPrograms(
          //   trainerName: trainerFirstName,
          //   user: user,
          //   student: student,
          //   skillsO: skillsO,
          // )
        ],
      ),
    );
  }
}
