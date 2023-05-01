import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Admin/screens/Company/addCompany/add_company_screen.dart';
import 'package:uptrain/src/features/Admin/screens/Company/companies_header.dart';
import 'package:uptrain/src/utils/theme/widget_themes/button_theme.dart';
import '../../../../../responsive.dart';
import '../../../../constants/size_config.dart';
import '../../controllers/MenuAppController.dart';
import '../main/components/side_menu.dart';
import 'companies.dart';

class Body extends StatelessWidget {
  Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
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
                      const CompanyHeader(),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(45),
                            width: getProportionateScreenWidth(50),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                // shape: RoundedRectangleBorder(
                                // borderRadius: BorderRadius.circular(15)),
                                backgroundColor: tPrimaryColor,
                                side: const BorderSide(
                                  width: 1.5,
                                  color: tLightColor,
                                ),
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddCompanyScreen())),
                              child: const Text(
                                "Add Company",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Ubuntu'),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      const SizedBox(
                        width: 1200,
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
