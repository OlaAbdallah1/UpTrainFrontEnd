import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';

import '../../../constants/size_config.dart';
import 'employee_dashboard_body.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  Map<String, dynamic> employee;
  Map<String, dynamic> user;

  EmployeeDashboardScreen({
    required this.employee,
    required this.user,
    super.key,
  });

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  late Map<String, dynamic> combined = {};
  Employee _employee = Employee(
      email: '',
      first_name: '',
      last_name: '',
      field: '',
      phone: '',
      photo: '',
      location: '',field_id: 0);
  void combineData() {
    combined.addAll(widget.user);
    combined.addAll(widget.employee);
    print(combined);
    _employee = Employee.fromJson(combined);
  }

  @override
  void initState() {
    combineData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_employee.email);
    SizeConfig().init(context);

    return Scaffold(
      body: Body(
        employee: _employee,
      ),
    );
  }
}
