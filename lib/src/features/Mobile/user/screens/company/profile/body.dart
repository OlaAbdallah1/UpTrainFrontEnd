import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';

import 'company_details.dart';

class Body extends StatelessWidget {
  final String companyName;
  Body({
    required this.companyName,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
           Text(
            companyName,
            style: const TextStyle(
                color: tPrimaryColor,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          CompanyDetails(companyName: companyName)
        ],
      ),
    );
  }
}
