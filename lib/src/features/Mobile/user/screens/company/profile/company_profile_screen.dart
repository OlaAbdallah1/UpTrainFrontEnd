import 'package:flutter/material.dart';

import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../authentication/models/skills.dart';
import 'body.dart';

class CompanyAccount extends StatelessWidget {
  static String routeName = "/";
  final String companyName;
   final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;
  const CompanyAccount({super.key, required this.companyName, required this.user,
      required this.student,
      required this.skillsO});
  @override
  Widget build(BuildContext context) {
    print(companyName);
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(companyName: companyName,user: user, student: student, skillsO: skillsO,),
    );
  }
}
