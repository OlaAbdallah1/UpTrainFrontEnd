import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

import '../../../../constants/size_config.dart';
import 'body.dart';

class ProgramsScreen extends StatelessWidget {
  Trainer company;
   ProgramsScreen({super.key,required this.company});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(
        trainer: company,
      ),
    );
  }
}
