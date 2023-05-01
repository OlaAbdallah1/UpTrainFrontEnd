

import 'package:flutter/material.dart';
import '../../../../../constants/size_config.dart';
import 'body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
     SizeConfig().init(context);
     return const Scaffold(
      body: Body(),
    );
   
  }
}
