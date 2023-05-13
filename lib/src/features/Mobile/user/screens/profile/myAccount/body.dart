import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import '../../../../authentication/models/skills.dart';
import '../profile_pic.dart';
import 'account_details.dart';

class Body extends StatelessWidget {
   final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skills;
  const Body({super.key, 
  required this.user,
  required this.student,
  required this.skills
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),

          Text(
            "Account Details",
            style: TextStyle(
                color: tPrimaryColor,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          AccountDetails(user: user, student:student,skillsO: skills,),
        ],
      ),
    );
  }
}
