import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../authentication/models/skills.dart';
import 'body.dart';

class TrainerAccount extends StatelessWidget {
  static String routeName = "/";
  final String trainer;
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO; 
  const TrainerAccount( {super.key, required this.trainer,
  required this.user, required this.student, required this.skillsO
  });
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(trainer: trainer, user: user, student: student, skillsO: skillsO,),
    );
  }
}
