import 'package:flutter/material.dart';

import '../../../../../constants/size_config.dart';
import 'body.dart';

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(),
    );
  }
}
