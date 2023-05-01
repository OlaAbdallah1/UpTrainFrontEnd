import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/myAccount/my_account.dart';
import 'profile_pic.dart';
import 'profile_menu.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            "Your Profile",
            style: headingStyle,
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          ProfilePic(),
          SizedBox(height: getProportionateScreenHeight(20)),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyAccount()))
                },
            
          ),
          ProfileMenu(
            text: "Tasks",
            icon: "assets/icons/tasks-list-svgrepo-com.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}
