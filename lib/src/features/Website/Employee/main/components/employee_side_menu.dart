import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Website/Employee/Students/students_screen.dart';
import 'package:uptrain/src/features/Website/Employee/TrainingStudents/training_students.dart';
import 'package:uptrain/src/features/Website/Employee/TrainingStudents/training_students_screen.dart';
import 'package:uptrain/src/features/Website/Employee/employee_dashboard.dart';

import '../../../../../constants/size_config.dart';
import '../../../Admin/models/Employee.dart';
import '../../../../Mobile/authentication/screens/login/login_screen.dart';

class EmployeeSideMenu extends StatelessWidget {
  Employee employee;
  EmployeeSideMenu({
    required this.employee,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/download.png",
                  color: tPrimaryColor,
                ),
                const Text(
                  tAppName,
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                      color: tPrimaryColor),
                )
              ],
            ),
          ),
          DrawerListTile(
              title: "Dashboard",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () => {}),
          DrawerListTile(
            title: "Students",
            svgSrc: "assets/icons/User.svg",
            press: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentsScreen(
                          employee: employee,
                        ))),
          ),
          DrawerListTile(
            title: "Students rolled into programs",
            svgSrc: "assets/icons/User.svg",
            press: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TrainingStudentsScreen(
                          employee: employee,
                        ))),
          ),
          // DrawerListTile(
          //   title: "Profile",
          //   svgSrc: "assets/icons/menu_profile.svg",
          //   press: () =>Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => EmployeeProfilePage(employee: employee,))),
          // ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/Log out.svg",
            press: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen())),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: tPrimaryColor,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: tPrimaryColor),
      ),
    );
  }
}
