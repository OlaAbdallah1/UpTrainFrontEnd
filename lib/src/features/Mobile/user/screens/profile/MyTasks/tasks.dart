import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/user/models/studentApplication.dart';
import 'package:uptrain/src/features/Mobile/user/models/user_task.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/MyApplications/program_app_details.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/MyTasks/tasks_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uptrain/src/features/Mobile/user/models/task.dart';
import '../../../../../../constants/connections.dart';
import 'dart:convert';

import '../../../../authentication/models/user.dart';

class Tasks extends StatefulWidget {
  // Tasks({Key? key}) : super(key: key);
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;

  const Tasks({
    super.key,
    required this.user,
    required this.student,
  });

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  late Map<String, dynamic> combined = {};

  late User _user = User(
      id: 0,
      email: '',
      firstName: '',
      lastName: '',
      phone: '',
      field: '',
      photo: '',
      location: '',
      field_id: 0,
      location_id: 0);

  void combineData() {
    combined.addAll(widget.user);
    combined.addAll(widget.student);
    // print(combined);
    _user = User.fromJson(combined);
  }

  @override
  void initState() {
    combineData();

    super.initState();
  }

  @override
  void dispose() {
    futureTasks = fetchTasks();
    super.dispose();
  }

  UserTasks userTasks = UserTasks(
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
      tasks: []);

  List<UserTasks> studentTasks = [];

  List<Task> tasks = [];
  late Future<List<Task>> futureTasks = fetchTasks();
  Future<List<Task>> fetchTasks() async {
    String url = "http://$ip/api/getStudentTasks/${_user.id}";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      userTasks = UserTasks(
          tasks: (responseData['tasks'] as List<dynamic>)
              .map((taskJson) => Task.fromJson(taskJson))
              .toList(),
          user: _user);

      // print(userTasks.tasks);
      for (Task task in userTasks.tasks) {
        tasks.add(task);
      }

      return tasks;
    }
    return userTasks.tasks;
  }

  @override
  Widget build(BuildContext context) {
    print(_user.id);
    return Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
              future: futureTasks,
              builder: (context, snapshot) {
                // Text(tasks.first.program_name + ' Tasks',
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontFamily: 'Ubuntu',
                //         fontSize: 25,
                //         color: tPrimaryColor));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        side: BorderSide(
                          color: tPrimaryColor,
                          width: 1.0,
                        ),
                      ),
                      shadowColor: tPrimaryColor,
                      // color: tLightColor,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                      child: Column(children: [
                                    ListTile(
                                      title: Text(
                                        "No Tasks yet!",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    16),
                                            color: tPrimaryColor,
                                            // fontFamily: 'Ubuntu',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]))
                                ])
                          ]));
                } else if (snapshot.hasData) {
                  // Display the list of task files
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // scrollDirection: Axis.vertical,
                      itemCount: tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Column(
                            children: [
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              Row(
                                children: [
                                  const Text(
                                    'Title',
                                    style: TextStyle(
                                        color: tPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Ubuntu',
                                        decoration: TextDecoration.underline),
                                  ),
                                  SizedBox(
                                      width: getProportionateScreenWidth(15)),
                                  Text(snapshot.data![index].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                          color: Colors.black)),
                                ],
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              Row(
                                children: [
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                        color: tPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Ubuntu',
                                        decoration: TextDecoration.underline),
                                  ),
                                  SizedBox(
                                      width: getProportionateScreenWidth(15)),
                                  Text(snapshot.data![index].description,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                          color: Colors.black)),
                                ],
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              Row(
                                children: [
                                  const Text(
                                    'Deadline',
                                    style: TextStyle(
                                        color: tPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Ubuntu',
                                        decoration: TextDecoration.underline),
                                  ),
                                  SizedBox(
                                      width: getProportionateScreenWidth(15)),
                                  Text(snapshot.data![index].deadline,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black)),
                                  IconButton(
                                    onPressed: () async {
                                      final response = await http.post(Uri.parse(
                                          'http://$ip/api/taskDone/${snapshot.data![index].id}'));

                                      print(response.body);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MyTasks(
                                                    student: widget.student,
                                                    user: widget.user,
                                                  )));

                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  '${snapshot.data![index].title} Task Done')));
                                    },
                                    icon: const Icon(Icons.task_rounded),
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                              const Divider(
                                color: tLightColor,
                                thickness: 1,
                              )
                            ],
                          ),
                        );
                      });
                } else {
                  // No data available
                  return const Center(child: Text('No task files found'));
                }
              },
            )));
  }
}
