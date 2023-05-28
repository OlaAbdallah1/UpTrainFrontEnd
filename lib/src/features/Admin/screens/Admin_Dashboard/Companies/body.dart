import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import '../../../../../../responsive.dart';

import '../../../../../constants/size_config.dart';
import 'AddCompany/add_company_screen.dart';
import 'companies.dart';
import 'companies_header.dart';

class Body extends StatelessWidget {
  Body({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: AdminSideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: AdminSideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CompanyHeader(),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      SizedBox(
                        width: 1500,
                        child: CompanyPage(),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
    // return SafeArea(
    //   child: SizedBox(
    //     width: double.infinity,
    //     child: Padding(
    //       padding:
    //           EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SizedBox(height: getProportionateScreenHeight(20)),
    //             const CompanyHeader(),
    //             SizedBox(
    //               height: getProportionateScreenHeight(20),
    //             ),
    //             Expanded(child: Row(
    //               children: [

    //             ],)
    //           ),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   children: [
    //                     SizedBox(
    //                       width: getProportionateScreenWidth(12),
    //                     ),
    //                     Text(
    //                       "All Companies ",
    //                       style: TextStyle(
    //                           // decoration: TextDecoration.underline,
    //                           fontSize: getProportionateScreenHeight(18),
    //                           color: tPrimaryColor,
    //                           fontFamily: 'Ubuntu',
    //                           fontWeight: FontWeight.w500),
    //                     ),
    //                   ],
    //                 ),
    //                 CompanyPage(),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
