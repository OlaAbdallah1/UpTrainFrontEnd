import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';

import '../../../../constants/size_config.dart';
import 'body.dart';

class ProgramsScreen extends StatelessWidget {
  Company company;
   ProgramsScreen({super.key,required this.company});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(
        company: company,
      ),
    );
  }
}
