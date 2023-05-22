
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/Companies/companies.dart';

import '../../../../../../responsive.dart';
import '../../../../../constants/colors.dart';
import '../../../controllers/MenuAppController.dart';
import '../components/header.dart';

class CompanyHeader extends StatelessWidget {
  CompanyHeader({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Column(
            children: [
              const Text(
                "Companies",
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: tPrimaryColor),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
            ],
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          // Expanded(child:companiesSearchField()),
        ProfileCard()
      ],
    );
  }
}

