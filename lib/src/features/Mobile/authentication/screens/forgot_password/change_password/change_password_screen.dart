import 'package:flutter/material.dart';
import 'body.dart';

class ChangePasswordScreen extends StatelessWidget {
  static String routeName = "/change_password";

  String email;
    ChangePasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email),
    );
  }
}
