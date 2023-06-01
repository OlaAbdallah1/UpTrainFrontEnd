import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Website/Company/components/company_header.dart';
import 'package:uptrain/src/features/Website/Company/components/company_side_menu.dart';
import '../../../../../../../responsive.dart';


class CompanyProfilePage extends StatelessWidget {
  Company company;
  CompanyProfilePage({
    Key? key,
    required this.company
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: CompanySideMenu(company: company,),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: CompanySideMenu(company: company,),
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
                      CHeader(company: company,),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: tPrimaryColor,
                            child: Image.asset(
                              'assets/images/${company.photo}',
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            "${company.name}",
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
                                subtitle: Text(company.email),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Phone'),
                                subtitle: Text(company.phone),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('Location'),
                                subtitle: Text(company.location),
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
                                title: const Text('Company Name'),
                                subtitle: Text(
                                    '${company.name}'),
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
