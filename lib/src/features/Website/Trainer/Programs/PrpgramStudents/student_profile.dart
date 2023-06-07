import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user_skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/task.dart';
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
    futureUser = getUser();
    tasks = getTasks();
    super.initState();
  }

  late UserSkills userSkills = UserSkills(
      user: User(
          id: 0,
          email: '',
          firstName: '',
          lastName: '',
          phone: '',
          photo: '',
          location: '',
          location_id: 0,
          field_id: 0,
          field: ''),
      skills: []);

  late Future<UserSkills> futureUser = getUser();

  Future<UserSkills> getUser() async {
    print(widget.student.id);
    print(widget.student.lastName);

    final response = await http
        .get(Uri.parse('http://$ip/api/getUser/${widget.student.id}'));
    List<dynamic> decodedData = json.decode(response.body);

    List<Map<String, dynamic>> data = decodedData.cast<Map<String, dynamic>>();
    UserSkills userSkills = UserSkills(
      user: User.fromJson(data[0]['student']),
      skills: (data[0]['skills'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map<Skill>((json) => Skill.fromJson(json))
          .toList(),
    );

    return userSkills;
  }

  List<Task> tasksData = [];
  late Future<List<Task>> tasks;
  Future<List<Task>> getTasks() async {
    String url = "http://$ip/api/getDoneTask/${widget.student.id}";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    print(responseData);
    if (response.statusCode == 201) {
      for (Map task in responseData) {
        tasksData.add(Task.fromJson(task));
      }
      print(tasksData.first);
      return tasksData;
    } else {
      return tasksData;
    }
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
                      children: [
                        FutureBuilder<UserSkills?>(
                          future: getUser(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(); // Show a loading indicator while waiting for data
                            } else if (snapshot.hasError) {
                              return Text(
                                  'Error: ${snapshot.error}'); // Show an error message if an error occurs
                            } else if (snapshot.hasData) {
                              UserSkills? userSkills = snapshot.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ... your existing code ...
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipOval(
                                            child: Image.asset(
                                                'assets/images/${userSkills!.user.photo}')),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Text(
                                        "${userSkills?.user.firstName} ${userSkills?.user.lastName}",
                                        style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: tPrimaryColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  // ... your existing code ...
                                  ListTile(
                                    leading: const Icon(Icons.email),
                                    title: const Text('Email'),
                                    subtitle:
                                        Text(userSkills?.user.email ?? ''),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.phone),
                                    title: const Text('Phone'),
                                    subtitle:
                                        Text(userSkills?.user.phone ?? ''),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.location_city),
                                    title: const Text('Location'),
                                    subtitle:
                                        Text(userSkills?.user.location ?? ''),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.settings),
                                    title: const Text('Skills'),
                                    subtitle: Wrap(
                                      spacing: 4,
                                      children: userSkills!.skills
                                          .map((e) => Text(e.name))
                                          // .map((skill) => Text(
                                          //       (skill.name),
                                          //     ))
                                          .toList(),
                                    ),
                                  ),
                                  // ... your existing code ...
                                ],
                              );
                            } else {
                              return Text(
                                  'No data available'); // Show a message if no data is available
                            }
                          },
                        ),
                        SizedBox(
                          height: 250,
                          child: Expanded(
                            child: FutureBuilder(
                              future: tasks,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return SizedBox(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              title: Text(
                                                  snapshot.data![index].title),
                                              subtitle: Text(snapshot
                                                      .data![index]
                                                      .description +
                                                  ' for ' +
                                                  snapshot.data![index]
                                                      .program_name),
                                            );
                                          }));
                                } else {
                                  return Text(
                                      'No data available'); // Show a message if no data is available
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
