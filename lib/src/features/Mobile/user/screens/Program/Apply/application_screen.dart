import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/utils/theme/widget_themes/appbar.dart';

import '../../../../authentication/models/skills.dart';
import 'body.dart';

class ApplicationScreen extends StatelessWidget {
  static String routeName = "/apply";
  final String title;
  final int programId;
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;

   ApplicationScreen(
      {super.key,
      required this.programId,
      required this.title,
      required this.skillsO,
      required this.user,
      required this.student});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: buildAppBar(),
      body: Body(
        title: title,
        programId: programId,
        user: user,
        student: student,
        skillsO: skillsO,
      ),
    );
  }
}
