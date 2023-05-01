import 'package:flutter/material.dart';

import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/appbar.dart';
import 'body.dart';

class CompanyAccount extends StatelessWidget {
  static String routeName = "/";
 final String companyName;
  const CompanyAccount({super.key,required this.companyName});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(companyName: companyName),
    );
  }
}
