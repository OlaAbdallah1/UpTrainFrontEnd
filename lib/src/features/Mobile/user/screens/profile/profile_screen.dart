import 'package:flutter/material.dart';

import '../../../../../../enums.dart';
import '../../../../../constants/size_config.dart';
import '../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../../utils/theme/widget_themes/bottom_nav_bar.dart';
import '../../../authentication/models/skills.dart';
import '../../../authentication/models/user.dart';
import 'body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  late List<Skill> skills;
  
   ProfileScreen({super.key, 
  required this.user,
  required this.student,
  required this.skills,
  });
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: buildAppBar(),
      body: Body(user: user, student:student, skills: skills,),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile, user: user,student: student, skills: skills,),
    );
  }
}
