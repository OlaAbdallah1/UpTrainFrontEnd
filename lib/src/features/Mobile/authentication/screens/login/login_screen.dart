import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/image_strings.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/utils/background.dart';

import '../../../../../../responsive.dart';
import '../student_signup/sign_up_screen.dart';
import 'body.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "/login";

  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const Body(),
          desktop: Row(
            children: [
              Expanded(
                child: Image.asset(tWelcomeImage),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tAppName,
                      style: headingStyle,
                    ),
                    Text(
                      "Login with your Email and Password",
                      style: TextStyle(
                          fontSize: getProportionateScreenHeight(18),
                          fontFamily: 'Ubuntu',
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          tablet: Row(
            children: [
              Expanded(
                child: Image.asset(tWelcomeImage),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tAppName,
                      style: headingStyle,
                    ),
                    Text(
                      "Login with your Email and Password",
                      style: TextStyle(
                          fontSize: getProportionateScreenHeight(18),
                          fontFamily: 'Ubuntu',
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
