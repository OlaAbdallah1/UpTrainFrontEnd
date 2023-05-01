import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';

import '../../../../../../enums.dart';
import '../../../../../utils/theme/widget_themes/appbar.dart';
import '../../../../../utils/theme/widget_themes/bottom_nav_bar.dart';
import 'body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  //  final User user ;
  const HomeScreen({super.key, 
  // required this.user
  });
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
