import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';

import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/user/models/program_skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'student_profile.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';

class ProgramStudents extends StatefulWidget {
  int programId;
  Trainer trainer;
  ProgramStudents({super.key, required this.programId, required this.trainer});

  @override
  State<ProgramStudents> createState() => _ProgramStudentsState();
}

class _ProgramStudentsState extends State<ProgramStudents> {
  @override
  void initState() {
    print(widget.programId);
    students = fetchProgramStudents();
    super.initState();
  }

  List<User> programStudents = [];
  late Future<List<User>> students;
  Future<List<User>> fetchProgramStudents() async {
    final response = await http.get(
        Uri.parse('http://$ip/api/getProgramStudents/${widget.programId}'));

    var responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      for (Map student in responseData) {
        programStudents.add(User.fromJson(student));
      }
      return programStudents;
    } else {
      return programStudents;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: getProportionateScreenHeight(160),
        child: ListView(scrollDirection: Axis.horizontal, children: [
          Card(
            child: FutureBuilder(
              future: students,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: ClipOval(
                                            child: Image.asset(
                                                'assets/images/${snapshot.data![index].photo}'))),
                                    TextButton(
                                        onPressed: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentProfilePage(
                                                      trainer: widget.trainer,
                                                      student: snapshot
                                                          .data![index]),
                                            )),
                                        child: Text(
                                          '${snapshot.data![index].firstName} ${snapshot.data![index].lastName} ☞',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ));
                      });
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ]));
  }
}
