import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Website/Company/components/company_header.dart';
import 'package:uptrain/src/features/Website/Company/components/company_side_menu.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_header.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_sideMaenu.dart';
import '../../../../../../../responsive.dart';

class TrainerProfilePage extends StatelessWidget {
  Trainer trainer;
  TrainerProfilePage({Key? key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: TrainerSideMenu(
        trainer: trainer,
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
                child: TrainerSideMenu(
                  trainer: trainer,
                ),
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
                      THeader(
                        trainer: trainer,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            child: Image.network(
                                "https://res.cloudinary.com/dsmn9brrg/image/upload/v1673876307/dngdfphruvhmu7cie95a.jpg"),
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            "${trainer.first_name} ${trainer.last_name}",
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
                                subtitle: Text(trainer.email),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Phone'),
                                subtitle: Text(trainer.phone),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('Location'),
                                // subtitle: Text(trainer),
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
                                title: const Text('Trainer Name'),
                                subtitle: Text(
                                    '${trainer.first_name} ${trainer.last_name}'),
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
