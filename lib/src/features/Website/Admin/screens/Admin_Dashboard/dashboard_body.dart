import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/components/header.dart';
import '../../../../../../responsive.dart';
import 'components/statistics.dart';

class Body extends StatelessWidget {
    // Map<String, dynamic> admin;

  Body({
    super.key,
    // required this.admin
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer:  AdminSideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
               Expanded(
                // default flex = 1
                child: AdminSideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Header(),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      const SizedBox(
                        width: 1100,
                        child: Statistics(),
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
