import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/MyTasks/tasks.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../authentication/models/skills.dart';

class MyTasks extends StatelessWidget {
  static String routeName = "/profile";
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;

  const MyTasks({
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
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Your Tasks',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu',
                        fontSize: 25,
                        color: tPrimaryColor))
              ],
            ),
            Tasks(user: user, student: student),
          ],
        ),
      ),
      
    );
  }
}
