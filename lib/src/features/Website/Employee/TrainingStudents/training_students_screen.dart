import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';

import '../../../../constants/size_config.dart';
import 'body.dart';

class TrainingStudentsScreen extends StatelessWidget {
  String routeName = '/students';
  Employee employee;
  TrainingStudentsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(
        employee: employee,
      ),
    );
  }
}
