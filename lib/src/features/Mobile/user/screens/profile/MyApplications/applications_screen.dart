import 'package:flutter/material.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../authentication/models/skills.dart';
import 'applications.dart';

class MyApplications extends StatelessWidget {
  static String routeName = "/profile";
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  const MyApplications({
    super.key,
    required this.user,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: getProportionateScreenHeight(10)),
            Text(
              "Applications",
              style: TextStyle(
                  color: tPrimaryColor,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            SizedBox(
              height: 200,
              child: Applications(user: user, student: student),
            )
          ],
        ),
      ),
    );
  }
}
