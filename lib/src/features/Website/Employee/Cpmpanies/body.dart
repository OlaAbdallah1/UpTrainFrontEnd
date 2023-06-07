import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import 'package:uptrain/src/features/Website/Employee/main/components/employee_side_menu.dart';
import 'package:uptrain/src/features/Website/Employee/main/components/header.dart';
import '../../../../../../../responsive.dart';

import 'companies.dart';

class Body extends StatelessWidget {
  Employee employee;
  Body({
    super.key,
    required this.employee
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: EmployeeSideMenu(
        employee: employee,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: EmployeeSideMenu(
        employee: employee,
      ),
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
                      EHeader(employee: employee,),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      SizedBox(
                        width: 1500,
                        child: CompanyPage(employee: employee,),
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
