import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Mobile/user/screens/trainer/trainer_programs.dart';
import 'package:url_launcher/url_launcher.dart';

import 'trainer_profile_details.dart';

class Body extends StatelessWidget {
  final String trainer;

  Body({
    required this.trainer,
  });
  @override
  Widget build(BuildContext context) {
    int index = trainer.indexOf(' ');
    String trainerFirstName = trainer.substring(0, index);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          TrainerDetails(trainer: trainerFirstName),
         Row(        mainAxisAlignment: MainAxisAlignment.start,

          children:[
 Text("Programs",style: TextStyle(
                fontSize: getProportionateScreenHeight(22),
                decoration: TextDecoration.underline,
                fontFamily: 'Ubuntu',
                color: tPrimaryColor),),
         ]),
         
          TrainerPrograms(trainerName: trainerFirstName)
        ],
      ),
    );
  }
 

}
