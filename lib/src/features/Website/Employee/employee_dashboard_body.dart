import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';
import 'package:uptrain/src/features/Website/Employee/main/components/header.dart';
import '../../../../../responsive.dart';
import 'main/components/employee_side_menu.dart';

class Body extends StatelessWidget {
  Employee employee;

  Body({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    print(employee.email);
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: EmployeeSideMenu(employee : employee),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
               Expanded(
                // default flex = 1
                child: EmployeeSideMenu(employee : employee),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EHeader(employee: employee),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const SizedBox(
                        width: 1100,
                        // child: Statistics(),
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
