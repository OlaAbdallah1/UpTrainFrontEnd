import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';

import '../../../../../../enums.dart';
import '../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../../utils/theme/widget_themes/bottom_nav_bar.dart';
import '../../../authentication/models/skills.dart';
import 'body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  late  List<Skill> skills;

   HomeScreen({super.key, required this.user, required this.student, required this.skills});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print(user);
    print(student);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(
        user: user,
        student: student,
        skills : skills
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.home,
        user: user,
        student: student,
        skills: skills,
      ),
    );
  }
}
