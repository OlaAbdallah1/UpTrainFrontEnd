import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(30),
  fontWeight: FontWeight.bold,
  color: tPrimaryColor,
  fontFamily: 'Ubuntu',
  height: getProportionateScreenHeight(2),
);
final bodyTextStyle = TextStyle(
  fontSize: getProportionateScreenWidth(16),
  fontWeight: FontWeight.normal,
  color: Colors.black,
  height: getProportionateScreenHeight(1),
);
final textButtonStyle = TextStyle(
  fontSize: getProportionateScreenWidth(18),
  fontWeight: FontWeight.normal,
  fontFamily: 'Ubuntu',
  color: tPrimaryColor,
  height: getProportionateScreenHeight(1),
);

const String tAppName = "UPTRAIN";
// const String tAppTagLine = "Find Your Chance with us ";

const String tWelcomeSubTitle = "Let’s find your way!";
const String tSplashSubTitle1 = "With UPTRAIN, Get your best chanses!";
const String tSplashTitle2 = "";
const String tSplashSubTitle2 =
    "We help you connect with entities \n     to find your training chance";

const String tSplashTitle3 = "";
const String tSplashSubTitle3 =
    "And keep up with your trainee\n     to get everything done!";

//login form text
const String tLoginTiltle = "Welcome Back, ";
const String tLoginSubTiltle = "Keep in touch with amazing oppurtunities";
const String tForgetPassword = "Forget your password?";
const String tRememberMe = "Remember Me?";
const String tAlreadyHaveAnAccount = "Already have an account?";
