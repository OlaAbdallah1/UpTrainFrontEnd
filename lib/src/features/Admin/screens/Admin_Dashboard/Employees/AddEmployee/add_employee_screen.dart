import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';

import '../../../../../../../responsive.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../utils/background.dart';
import '../../../main/components/side_menu.dart';
import '../employees_header.dart';
import 'add_employee_form.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: AdminSideMenu(),
      body: SafeArea(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  // EmployeeHeader(),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  AddEmployeeForm()
                ]),
          ),
        ),
      ])),
    );
  }
}
