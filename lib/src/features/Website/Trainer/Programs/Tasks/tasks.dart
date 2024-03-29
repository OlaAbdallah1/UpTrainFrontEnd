import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/user/models/studentApplication.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Mobile/user/models/user_task.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/MyApplications/program_app_details.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/MyTasks/tasks_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uptrain/src/features/Mobile/user/models/task.dart';
import 'dart:convert';

class TrainerTasks extends StatefulWidget {
  // Tasks({Key? key}) : super(key: key);
  final Map<String, dynamic> user;
  final Map<String, dynamic> trainer;

  const TrainerTasks({
    super.key,
    required this.user,
    required this.trainer,
  });

  @override
  State<TrainerTasks> createState() => _TrainerTasksState();
}

class _TrainerTasksState extends State<TrainerTasks> {
  late Map<String, dynamic> combined = {};

  late Trainer _trainer = Trainer(
      id: 0,
      email: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      company: '');

  void combineData() {
    combined.addAll(widget.user);
    combined.addAll(widget.trainer);
    // print(combined);
    _trainer = Trainer.fromJson(combined);
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

  List<Task> tasks = [];
  late Future<List<Task>> futureTasks = fetchTasks();
  Future<List<Task>> fetchTasks() async {
    String url = "http://$ip/api/getTrainerTasks/${_trainer.id}";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    if (response.statusCode == 201) {}

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    print(_trainer.id);
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
                                          'http://$ip/api/trainer/deleteTask/${snapshot.data![index].id}'));

                                      print(response.body);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  TrainerTasks(
                                                    trainer: widget.trainer,
                                                    user: widget.user,
                                                  )));

                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  '${snapshot.data![index].title} Task ')));
                                    },
                                    icon: const Icon(Icons.delete),
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
