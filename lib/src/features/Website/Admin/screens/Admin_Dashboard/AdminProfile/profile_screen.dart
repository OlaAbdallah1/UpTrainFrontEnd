import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import '../../../../../../../responsive.dart';
import '../../../../../../constants/connections.dart';
import '../../../models/Employee.dart';
import 'package:http/http.dart' as http;

import 'profile_header.dart';

class AdminProfilePage extends StatefulWidget {
  AdminProfilePage({
    Key? key,
  });

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  @override
  void initState() {
    setAdmin();
    super.initState();
  }

  static Employee _admin = Employee(
      email: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      field: '',
      location: '',field_id: 0);


  Future<List<Employee>> getAdmin() async {
    final response = await http.get(Uri.parse('http://$ip/api/getAdmin'));

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Employee.fromJson(json)).toList();
  }

  void setAdmin() async {
    final admin = await getAdmin();
    try {
      setState(() {
        _admin = admin.first;
      });
    } catch (e) {
      print(e);
    }
  }

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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileHeader(),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: tPrimaryColor,
                            child: Image.asset(
                              'assets/images/download.png',
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            "${_admin.first_name} ${_admin.last_name}",
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                subtitle: Text(_admin.email),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Phone'),
                                subtitle: Text(_admin.phone),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('Location'),
                                subtitle: Text(_admin.location),
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    '${_admin.first_name} ${_admin.last_name}'),
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
                                        decoration: TextDecoration.underline,
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
            ),
          ],
        ),
      ),
    );
  }
}
