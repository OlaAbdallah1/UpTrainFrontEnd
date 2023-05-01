import 'package:flutter/widgets.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/splash/splash_screen.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/student_signup/sign_up_screen.dart';


// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
 

};