import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Program/Apply/application_screen.dart';

import '../../../../../../../enums.dart';
import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../../../utils/theme/widget_themes/bottom_nav_bar.dart';
import '../../../../../../utils/theme/widget_themes/button_theme.dart';
import 'body.dart';

class ProgramDetailsScreen extends StatelessWidget {
  static String routeName = "/program";

  final String title;
  final String image;
  final String description;
  final String details;
  final String company;
  final String startDate;
  final String endDate;
  final String trainer;

  ProgramDetailsScreen(
      {required this.title,
      required this.image,
      required this.description,
      required this.details,
      required this.company,
      required this.startDate,
      required this.endDate,
      required this.trainer});

  Trainer _trainer = new Trainer(
      email: '',
      password: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      company_id: 0);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: buildAppBar(),
      body: Body(
        title: title,
        image: image,
        description: description,
        details: details,
        company: company,
        startDate: startDate,
        endDate: endDate,
        trainer: _trainer.email,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultButton(
            text: "Apply Now!",
            press: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ApplicationScreen(title: title))),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          )
        ],
      ),
    );
  }
}
