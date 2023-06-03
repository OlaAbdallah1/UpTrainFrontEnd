import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Home/Notifications/notifications.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/MyTasks/tasks_screen.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/profile_screen.dart';
import 'package:http/http.dart' as http;

import '../../../constants/colors.dart';
import '../../../constants/connections.dart';
import '../../../features/Mobile/authentication/models/user.dart';
import '../../../features/Mobile/user/models/notification.dart';
import '../../../features/Mobile/user/screens/Home/home_page_screen.dart';
import '../../../features/Mobile/user/screens/Home/icon_btn.dart';
import '/enums.dart';

class CustomBottomNavBar extends StatefulWidget {
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
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureNotifications = getNotifications();
  }

  late List<UserNotification> notifications = [];
  late Future<List<UserNotification>> futureNotifications;

  Future<List<UserNotification>> getNotifications() async {
    final response =
        await http.get(Uri.parse('http://$ip/api/getNotifications'));
    final data = json.decode(response.body);

    List<UserNotification> fetchedNotifications = data
        .map<UserNotification>((json) => UserNotification.fromJson(json))
        .toList();

    setState(() {
      notifications = fetchedNotifications;
    });

    return fetchedNotifications;
  }

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
                  color: MenuState.home == widget.selectedMenu
                      ? tPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              user: widget.user,
                              student: widget.student,
                              skills: widget.skills,
                            ))),
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.tasks,
                  size: 25,
                  color: MenuState.tasks == widget.selectedMenu
                      ? tPrimaryColor
                      : inActiveIconColor,
                ),
                // icon: SvgPicture.asset("assets/icons/Task Icon.svg"),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyTasks(
                              student: widget.student,
                              user: widget.user,
                            ))),
              ),
              IconBtnWithCounter(
                icon: Icon(
                  FontAwesomeIcons.bell,
                  size: 25,
                  color: MenuState.notifications == widget.selectedMenu
                      ? tPrimaryColor
                      : inActiveIconColor,
                ),
                numOfitem: notifications.length,
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationsScreen(
                            notifications: notifications,
                            user: widget.user,
                            student: widget.student,
                            skills: widget.skills,
                          )));
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  width: 25,
                  color: MenuState.profile == widget.selectedMenu
                      ? tPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              user: widget.user,
                              student: widget.student,
                              skills: widget.skills,
                            ))),
              ),
            ],
          )),
    );
  }
}
