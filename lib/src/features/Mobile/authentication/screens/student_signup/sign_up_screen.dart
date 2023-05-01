import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/student_signup/sign_up_form.dart';

import '../../../../../../responsive.dart';
import '../../../../../constants/image_strings.dart';
import '../../../../../utils/background.dart';
import 'body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Body(),
    // );
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: Body(),
          desktop: Row(
            children: [
              Expanded(
                child: Column(children: [
                  Text("Create your account " ,style: TextStyle(fontSize: 40,
                  fontWeight: FontWeight.bold),)
                ]),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: SignUpForm(),
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
