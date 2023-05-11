import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';

import '../../../../../../enums.dart';
import '../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../../utils/theme/widget_themes/bottom_nav_bar.dart';
import 'body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final User user1;
  const HomeScreen(
      {super.key, required this.user, required this.user1, required this.student});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // print(user);
    // print(student);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(
        user1: user1,
        user: user,
        student: student,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.home,
        user: user,
        student: student,
      ),
    );
  }
}
