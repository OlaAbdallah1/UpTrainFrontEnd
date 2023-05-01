import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import 'body.dart';

class TrainerAccount extends StatelessWidget {
  static String routeName = "/";
  final String trainer;
  const TrainerAccount({super.key, required this.trainer});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(trainer: trainer),
    );
  }
}
