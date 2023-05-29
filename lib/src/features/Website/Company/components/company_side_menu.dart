import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Website/Company/Program/programs_screen.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';

import '../../../../constants/size_config.dart';
import '../Trainer/trainers_screen.dart';

class CompanySideMenu extends StatelessWidget {
  Company company;
  CompanySideMenu({
    Key? key,
required this.company
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
            title: "Programs",
            svgSrc: "assets/icons/menu_store.svg",
            press: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ProgramsScreen(),
            )),
          ),
          DrawerListTile(
            title: "Trainers",
            svgSrc: "assets/icons/User.svg",
            press: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TrainersScreen(company: company),
            )),
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
              title: "Profile",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () => {}
              // Navigator.push(context,
              // MaterialPageRoute(builder: (context) => CompanyProfilePage())),
              ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
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
