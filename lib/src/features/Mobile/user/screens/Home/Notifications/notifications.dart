import 'package:flutter/material.dart';
import 'package:uptrain/enums.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/notification.dart';
import 'package:uptrain/src/utils/theme/widget_themes/appbar.dart';
import 'package:uptrain/src/utils/theme/widget_themes/bottom_nav_bar.dart';
import 'body.dart';

class NotificationsScreen extends StatelessWidget {
  List<UserNotification> notifications = [];
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  late List<Skill> skills;
  NotificationsScreen(
      {super.key,
      required this.notifications,
      required this.user,
      required this.student,
      required this.skills});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(
        notifications: notifications,
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
