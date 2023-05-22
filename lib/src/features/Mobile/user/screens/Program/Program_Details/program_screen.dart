import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Program/Apply/application_screen.dart';

import '../../../../../../../enums.dart';
import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../../../utils/theme/widget_themes/bottom_nav_bar.dart';
import '../../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../../../authentication/models/skills.dart';
import 'body.dart';

class ProgramDetailsScreen extends StatelessWidget {
  static String routeName = "/program";

  final String title;
  final String image;
  final String details;
  final String company;
  final String startDate;
  final String endDate;
  final String trainer;
  final int programId;
  final int userId;

final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO; 

  ProgramDetailsScreen(
      {required this.programId,
      required this.userId,
        required this.title,
      required this.image,
      required this.details,
      required this.company,
      required this.startDate,
      required this.endDate,
      required this.trainer,
      required this.user,
      required this.skillsO,
      required this.student
      });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(
        title: title,
        image: image,
        details: details,
        company: company,
        startDate: startDate,
        endDate: endDate,
        trainer: trainer,
        user: user,
        student: student,
        skillsO: skillsO,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultButton(
            text: "Apply Now!",
            press: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ApplicationScreen(title: title,user: user, student: student, skillsO: skillsO,programId: programId,userId:userId))),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          )
        ],
      ),
    );
  }
}
