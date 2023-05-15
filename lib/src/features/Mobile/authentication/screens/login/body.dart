import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../constants/colors.dart';
import '../student_signup/sign_up_screen.dart';
import 'login_form.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20),),
          child: SingleChildScrollView(
            child: Column(
              children: [
            
                Text("Welcome Back", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Text(
                  "Login with your Email and Password",
                  style: bodyTextStyle,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                const LoginForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(18),
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, SignUpScreen.routeName);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(20),
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              color: tPrimaryColor),
                        ),
                      )
                    ],
                  ),
                // Text(
                //   "Or Login with ",
                //   style: bodyTextStyle,
                // ),
                // SizedBox(height: SizeConfig.screenHeight * 0.015),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(
                //         onPressed: () {},
                //         icon: const Icon(
                //           FontAwesomeIcons.facebook,
                //           color: tPrimaryColor,
                //         )),
                //     SizedBox(width: SizeConfig.screenWidth * 0.02),
                //     IconButton(
                //         onPressed: () {},
                //         icon: const Icon(
                //           FontAwesomeIcons.linkedin,
                //           color: tSecondaryColor,
                //         )),
                //     SizedBox(width: SizeConfig.screenWidth * 0.02),
                //     IconButton(
                //         onPressed: () {},
                //         icon: const Icon(
                //           FontAwesomeIcons.google,
                //           color: Colors.red,
                //         )),
                //   ],
                // ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),

                // NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
