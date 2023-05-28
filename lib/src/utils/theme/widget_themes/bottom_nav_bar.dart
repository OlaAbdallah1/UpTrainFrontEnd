import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/profile_screen.dart';

import '../../../constants/colors.dart';
import '../../../features/Mobile/authentication/models/user.dart';
import '../../../features/Mobile/user/screens/Home/home_page_screen.dart';
import '../../../features/Mobile/user/screens/Home/icon_btn.dart';
import '/enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  late User user1;
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  late List<Skill> skills;
  CustomBottomNavBar(
      {Key? key,
      required this.selectedMenu,
      required this.user,
      required this.student,
      required this.skills})
      : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 10,
            color: tPrimaryColor,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.home,
                  size: 25,
                  color: MenuState.home == selectedMenu
                      ? tPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              user: user,
                              student: student,
                              skills: skills,
                            ))),
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.tasks,
                  size: 25,
                  color: MenuState.tasks == selectedMenu
                      ? tPrimaryColor
                      : inActiveIconColor,
                ),
                // icon: SvgPicture.asset("assets/icons/Task Icon.svg"),
                onPressed: () {},
              ),
              IconBtnWithCounter(
                svgSrc: "assets/icons/Chat bubble Icon.svg",
                numOfitem: 1,
                press: () {},
                color: MenuState.tasks == selectedMenu
                      ? tPrimaryColor
                      : inActiveIconColor,
              ),
              IconBtnWithCounter(
                svgSrc: "assets/icons/Bell.svg",
                numOfitem: 3,
                press: () {},
                color: MenuState.tasks == selectedMenu
                      ? tPrimaryColor
                      : inActiveIconColor,
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  width: 25,
                  color: MenuState.profile == selectedMenu
                      ? tPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              user: user,
                              student: student,
                              skills: skills,
                            ))),
              ),
            ],
          )),
    );
  }
}
