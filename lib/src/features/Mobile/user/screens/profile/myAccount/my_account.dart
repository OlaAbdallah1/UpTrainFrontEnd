import 'package:flutter/material.dart';

import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../authentication/models/skills.dart';
import 'body.dart';

class MyAccount extends StatelessWidget {
  static String routeName = "/profile";
 final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skills;
  const MyAccount({super.key, 
  required this.user,
  required this.student,
  required this.skills
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(user: user, student: student,skills: skills,),
    );
  }
}
