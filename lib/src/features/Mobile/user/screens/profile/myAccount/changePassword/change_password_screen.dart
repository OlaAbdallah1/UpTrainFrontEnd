import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'body.dart';

class ChangeUserPasswordScreen extends StatelessWidget {
  static String routeName = "/change_password";
 String email;
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;
  ChangeUserPasswordScreen(
      {super.key,
      required this.email,
      required this.user,
      required this.student,
      required this.skillsO});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email,user: user,skillsO: skillsO,student: student,),
    );
  }
}
