import 'package:flutter/material.dart';

import '../../../../../constants/size_config.dart';
import 'body.dart';

class EmployeesScreen extends StatelessWidget {
  
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(body: Body(),);
  }
}
