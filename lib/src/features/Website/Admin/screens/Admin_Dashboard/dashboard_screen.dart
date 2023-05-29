import 'package:flutter/material.dart';

import '../../../../../constants/size_config.dart';
import 'dashboard_body.dart';

class DashboardScreen extends StatelessWidget {
  // Map<String, dynamic> admin;

   DashboardScreen({
    super.key,
    // required this.admin
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(),
    );
  }
}
