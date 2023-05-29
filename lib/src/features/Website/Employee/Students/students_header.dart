import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';

import '../../../../../../responsive.dart';
import '../../../../constants/colors.dart';
import '../../Admin/controllers/MenuAppController.dart';
import '../../Admin/models/Employee.dart';
import '../main/components/header.dart';

class StudentHeader extends StatelessWidget {
  Employee employee;
   StudentHeader({
    required this.employee,
    Key? key,
  }) : super(key: key);

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
               Text(
                "${employee.field} Students",
                style: const TextStyle(
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
        ProfileCard(
          employee: employee,
        )
      ],
    );
  }
}
