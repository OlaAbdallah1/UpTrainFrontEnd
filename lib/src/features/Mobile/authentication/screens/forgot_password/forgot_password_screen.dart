import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/forgot_password/body.dart';

import '../../../../../constants/size_config.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Body(),
    );
  }
}
