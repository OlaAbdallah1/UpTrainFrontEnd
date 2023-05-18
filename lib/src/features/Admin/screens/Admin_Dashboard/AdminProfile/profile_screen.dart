import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import '../../../../../../responsive.dart';
import '../../../../../constants/connections.dart';
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

  static Employee _admin =
      Employee(email: '', first_name: '', last_name: '', phone: '', photo: '',field: '');

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
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: tPrimaryColor,
                            child: Image.asset(
                              'assets/images/download.png',
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Text(
                            "${_admin.first_name} ${_admin.last_name}",
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: tPrimaryColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ListTile(
                                leading: Icon(Icons.email),
                                title: Text('Email'),
                                subtitle: Text(_admin.email),
                              ),
                              ListTile(
                                leading: Icon(Icons.phone),
                                title: Text('Phone'),
                                subtitle: Text(_admin.phone),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Account Information',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text('Username'),
                                subtitle: Text(
                                    '${_admin.first_name} ${_admin.last_name}'),
                              ),
                              ListTile(
                                leading: Icon(Icons.lock),
                                title: Text('Password'),
                                subtitle: Text('********'),
                              ),
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
