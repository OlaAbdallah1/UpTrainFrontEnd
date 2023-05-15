import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Admin/controllers/MenuAppController.dart';
import 'package:uptrain/src/features/Admin/screens/main/main_screen.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/welcome_screen/welcome_screen.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Home/home_page_screen.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/profile_screen.dart';

import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final User user;

  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: MainScreen(),
       home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: LoginScreen(),
      ),
    );
  }
}
