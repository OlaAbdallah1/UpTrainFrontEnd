import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';

import 'body.dart';

class CompaniesScreen extends StatelessWidget {
  Employee employee;
   CompaniesScreen({super.key,required this.employee});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(employee: employee,),
    );
  }
}
