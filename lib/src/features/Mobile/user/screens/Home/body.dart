import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Home/programs.dart';

import 'home_header.dart';

class Body extends StatelessWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;

  Body(
      {super.key,
      required this.user,
      required this.student});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                const HomeHeader(),
                //  Text(user.email),
                SizedBox(height: getProportionateScreenHeight(10)),

                Programs(
                  student: student,
                  user: user,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
