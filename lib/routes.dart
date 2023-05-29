import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';
import 'package:uptrain/src/features/Website/Employee/Students/students_screen.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/splash/splash_screen.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/student_signup/sign_up_screen.dart';


// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  '/students':(context)=>StudentsScreen(employee: Employee(email: '', first_name: '', last_name: '', field: '', field_id: 0, phone: '', photo: '', location: '')),
  
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
 

};