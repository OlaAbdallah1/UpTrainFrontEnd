import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/utils/theme/widget_themes/appbar.dart';

import 'body.dart';

class ApplicationScreen extends StatelessWidget {
  static String routeName = "/apply";
  final String title;
  const ApplicationScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: buildAppBar(),
      body: Body(title: title),
    );
  }
}
