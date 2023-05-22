import 'package:flutter/material.dart';

import '../../constants/size_config.dart';
import 'employee_dashboard_body.dart';


class EmployeeDashboardScreen extends StatelessWidget {
  // Map<String, dynamic> admin;

   EmployeeDashboardScreen({
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
