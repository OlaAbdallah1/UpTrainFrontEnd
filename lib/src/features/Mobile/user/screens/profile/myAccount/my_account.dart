import 'package:flutter/material.dart';

import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import 'body.dart';

class MyAccount extends StatelessWidget {
  static String routeName = "/profile";

  const MyAccount({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }
}
