
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user_skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_header.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_sideMaenu.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';
import '../../../../../../../responsive.dart';

import 'package:http/http.dart' as http;

import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import '../../../../Mobile/authentication/models/skills.dart';

class StudentProfilePage extends StatefulWidget {
  User student;
  Trainer trainer;
  StudentProfilePage({
    required this.student,
    required this.trainer,
    Key? key,
  });

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  UserSkills userSkills = UserSkills(
      user: User(
          id: 0,
          email: '',
          firstName: '',
          lastName: '',
          phone: '',
          location: '',
          location_id: 0,
          field: '',
          photo: '',
          field_id: 0),
      skills: []);

  Future<User> getUser() async {
    print(widget.student.id);
    print(widget.student.lastName);

    final response = await http
        .get(Uri.parse('http://$ip/api/getUser/${widget.student.id}'));
    final data = json.decode(response.body);
    print(data[0]['user']);
    print(data[0]['skills']);
    final user = data.map<User>((json) => User.fromJson(json[0]['user']));
    final skills = (data[0]['skills'] as List<dynamic>)
        .map((json) => Skill.fromJson(json))
        .toList();

    setState(() {
      userSkills.user = user;
      userSkills.skills = skills;
      print(userSkills.user.email);
    });

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: TrainerSideMenu(
        trainer: widget.trainer,
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
                  trainer: widget.trainer,
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
                        trainer: widget.trainer,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          ClipOval(child: Image.asset(userSkills.user.photo)),
                          const SizedBox(width: 16.0),
                          Text(
                            "${userSkills.user.firstName} ${userSkills.user.lastName}",
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
                                subtitle: Text(userSkills.user.email),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Phone'),
                                subtitle: Text(userSkills.user.phone),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('Location'),
                                subtitle: Text(userSkills.user.location),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('Skills'),
                                subtitle: Text(userSkills.user.location),
                              ),
                              const Text("Skills",
                                  style: TextStyle(
                                      color: tPrimaryColor,
                                      fontSize: 20,
                                      fontFamily: 'Ubuntu',
                                      decoration: TextDecoration.underline)),
                              SizedBox(
                                  height: getProportionateScreenHeight(10)),
                              SizedBox(
                                width: getProportionateScreenWidth(200),
                                child: Wrap(
                                  spacing: 6,
                                  children: userSkills.skills
                                      .map((skill) => Text(
                                            skill.name,
                                            style: TextStyle(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                color: Colors.black,
                                                fontSize: 20),
                                          ))
                                      .toList(),
                                ),
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
