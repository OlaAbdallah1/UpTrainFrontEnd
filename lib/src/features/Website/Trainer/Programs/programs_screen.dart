import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

import '../../../../constants/size_config.dart';
import 'body.dart';

class TrainerProgramsScreen extends StatelessWidget {
  Trainer trainer;
   TrainerProgramsScreen({super.key,required this.trainer});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(
        trainer: trainer,
      ),
    );
  }
}
