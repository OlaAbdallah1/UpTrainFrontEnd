import 'package:flutter/material.dart';

import '../../../../../../enums.dart';
import '../../../../../constants/size_config.dart';
import '../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../../utils/theme/widget_themes/bottom_nav_bar.dart';
import 'body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
       appBar: buildAppBar(),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
