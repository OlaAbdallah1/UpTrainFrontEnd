// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';
import 'package:uptrain/src/features/Website/Employee/main/components/employee_side_menu.dart';
import 'package:uptrain/src/features/Website/Employee/main/components/header.dart';
import '../../../../../../../responsive.dart';
import 'package:http/http.dart' as http;

class EmployeeProfilePage extends StatelessWidget {
  Employee employee;

  EmployeeProfilePage({Key? key, required this.employee});

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
            
          ],
        ),
      ),
    );
  }
}
