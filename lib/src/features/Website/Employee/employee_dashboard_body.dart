import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/Employees/employees_screen.dart';
import 'package:uptrain/src/features/Website/Employee/main/components/header.dart';
import '../../../../../responsive.dart';
import 'main/components/employee_side_menu.dart';
import 'employee_profile.dart';

class Body extends StatelessWidget {
  Employee employee;

  Body({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    print(employee.email);
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: EmployeeSideMenu(employee: employee),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                child: EmployeeSideMenu(employee: employee),
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
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: ClipOval(
                                        child: Image.network(
                                            "https://res.cloudinary.com/dsmn9brrg/image/upload/v1673876307/dngdfphruvhmu7cie95a.jpg"),
                                      )),
                                  const SizedBox(width: 16.0),
                                  Text(
                                    "${employee.first_name} ${employee.last_name}",
                                    style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        color: tPrimaryColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Card(
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Personal Information',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      ListTile(
                                        leading: const Icon(Icons.email),
                                        title: const Text('Email'),
                                        subtitle: Text(employee.email),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.phone),
                                        title: const Text('Phone'),
                                        subtitle: Text(employee.phone),
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.location_city),
                                        title: const Text('Location'),
                                        subtitle: Text(employee.location),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Card(
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Account Information',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      ListTile(
                                        leading: const Icon(Icons.person),
                                        title: const Text('Username'),
                                        subtitle: Text(
                                            '${employee.first_name} ${employee.last_name}'),
                                      ),
                                      const ListTile(
                                        leading: Icon(Icons.lock),
                                        title: Text('Password'),
                                        subtitle: Text('*********'),
                                      ),
                                      TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            'Change Password',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: tSecondaryColor),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
