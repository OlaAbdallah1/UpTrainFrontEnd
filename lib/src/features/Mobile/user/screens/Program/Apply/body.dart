import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'application_form.dart';

class Body extends StatelessWidget {
   final String title;

  const Body({
    required this.title,
  });
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
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Application for $title program",
                  style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: tPrimaryColor,fontFamily: 'Ubuntu'),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                const ApplicationForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
