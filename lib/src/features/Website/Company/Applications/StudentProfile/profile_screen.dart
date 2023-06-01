import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Website/Company/components/company_header.dart';
import 'package:uptrain/src/features/Website/Company/components/company_side_menu.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';
import '../../../../../../../responsive.dart';

import 'package:http/http.dart' as http;

import '../../../../../constants/connections.dart';

class StudentProfilePage extends StatefulWidget {
  int student_id;
  Company company;
  StudentProfilePage({
    required this.student_id,
    required this.company,
    Key? key,
  });

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  late  User _user = User(
      id: 0,
      email: '',
      firstName: '',
      lastName: '',
      phone: '',
      photo: '',
      location: '',
      location_id: 0,
      field_id: 0,
      field: '');
      
  Future<List<User>> getUser() async {
    final response = await http.get(Uri.parse('http://$ip/api/getUser/${widget.student_id}'));

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  }

  void setAdmin() async {
    final user = await getUser();
    try {
      setState(() {
        _user = user.first;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: CompanySideMenu(company: widget.company,),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: CompanySideMenu(company: widget.company,),
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
                      CHeader(company: widget.company,),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          ClipOval(child: ImageFromUrl(imageUrl: _user.photo)),
                          const SizedBox(width: 16.0),
                          Text(
                            "${_user.firstName} ${_user.lastName}",
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
                                subtitle: Text(_user.email),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Phone'),
                                subtitle: Text(_user.phone),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('Location'),
                                subtitle: Text(_user.location),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('Skills'),
                                subtitle: Text(_user.location),
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
