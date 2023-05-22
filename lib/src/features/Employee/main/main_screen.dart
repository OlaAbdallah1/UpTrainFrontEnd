import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/features/Employee/employee_dashboard.dart';

import '../../../../../responsive.dart';
import '../../Admin/controllers/MenuAppController.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
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
              child: EmployeeDashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
