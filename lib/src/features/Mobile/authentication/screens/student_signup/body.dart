import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/profile_pic.dart';

import '../../../../../constants/size_config.dart';
import '../../../../../constants/text.dart';
import 'sign_up_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.001), // 1%
                Text("New Account", style: headingStyle),
                // ProfilePic(),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                const SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                SizedBox(height: getProportionateScreenHeight(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
