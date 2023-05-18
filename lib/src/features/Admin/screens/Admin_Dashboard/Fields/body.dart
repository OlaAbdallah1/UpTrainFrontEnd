import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import '../../../../../../responsive.dart';

import 'fields.dart';
import 'fields_header.dart';

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
                    children: const [
                      FieldHeader(),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       height: getProportionateScreenHeight(45),
                      //       width: getProportionateScreenWidth(50),
                      //       child: TextButton(
                      //         style: TextButton.styleFrom(
                      //           foregroundColor: Colors.white,
                      //           backgroundColor: tPrimaryColor,
                      //           side: const BorderSide(
                      //             width: 1.5,
                      //             color: tLightColor,
                      //           ),
                      //         ),
                      //         onPressed: () => Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     AddFieldScreen())),
                      //         child: const Text(
                      //           "Add Field",
                      //           style: TextStyle(
                      //               fontSize: 16,
                      //               color: Colors.white,
                      //               fontFamily: 'Ubuntu'),
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      SizedBox(
                        width: 1100,
                        child: FieldPage(),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
