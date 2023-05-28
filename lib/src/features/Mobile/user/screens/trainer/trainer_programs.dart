import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import '../../../authentication/models/skills.dart';
import '../../models/program.dart';
import '../Program/Apply/application_screen.dart';
import '../Program/Program_Details/program_screen.dart';


class TrainerPrograms extends StatefulWidget {
  final String trainerName;
final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO; 
  const TrainerPrograms({super.key, required this.trainerName, required this.user, required this.student, required this.skillsO});

  @override
  State<TrainerPrograms> createState() => _TrainerProgramsState();
}

class _TrainerProgramsState extends State<TrainerPrograms> {
  @override
  void initState() {
    super.initState();
  }

  List<Program> trainerPrograms = [];

  Future<List<Program>> fetchTrainerPrograms(String trainerName) async {
    final response = await http
        .get(Uri.parse('http://$ip/api/getTrainerPrograms/$trainerName'));

    var responseData = json.decode(response.body);
    print(responseData);
    if (response.statusCode == 201) {
      for (Map program in responseData) {
        trainerPrograms.add(Program.fromJson(program));
      }
      return trainerPrograms;
    } else {
      return trainerPrograms;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: getProportionateScreenHeight(160),
        child: ListView(scrollDirection: Axis.horizontal, children: [
          Card(
            child: FutureBuilder(
              future: fetchTrainerPrograms(widget.trainerName),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(2),
                              vertical: getProportionateScreenHeight(2)),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(50),
                                left: Radius.circular(20),
                              ),
                            ),
                            width: getProportionateScreenWidth(250),
                            child: Card(
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
                              color: tLightColor,
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
                                        child: Column(
                                          children: [
                                            ListTile(
                                                title: Text(
                                                  "${snapshot.data![index].title}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenHeight(
                                                              16),
                                                      color: tPrimaryColor,
                                                      // fontFamily: 'Ubuntu',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text(snapshot
                                                      .data![index].branch),
                                                  SizedBox(
                                                    height:
                                                        getProportionateScreenHeight(
                                                            10),
                                                  ),
                                                  Text(
                                                    " ${snapshot.data![index].start_date} \t-\t ${snapshot.data![index].end_date}",
                                                    style: TextStyle(
                                                        fontSize:
                                                            getProportionateScreenHeight(
                                                                13),
                                                        color: Colors.black87,
                                                        fontFamily: 'Ubuntu',
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ])),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProgramDetailsScreen(
                                                        programId: snapshot
                                                          .data![index].id,
                                                        company: snapshot.data![index].company,
                                                        title: snapshot
                                                            .data![index].title,
                                                        details: snapshot
                                                            .data![index]
                                                            .details,
                                                        image: snapshot
                                                            .data![index].image,
                                                        trainer: snapshot
                                                            .data![index]
                                                            .trainer,
                                                        startDate: snapshot
                                                            .data![index]
                                                            .start_date,
                                                        endDate: snapshot
                                                            .data![index]
                                                            .end_date,
                                                            programSkills: [],
                                                       user: widget.user,
                                                       student: widget.student,
                                                       skillsO: widget.skillsO,
                                                      ))),
                                          child: Text(
                                            "Show Details ",
                                            style: TextStyle(
                                                color: tPrimaryColor,
                                                decoration:
                                                    TextDecoration.underline),
                                          )),
                                      OutlinedButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ApplicationScreen(
                                                      programId: snapshot
                                                          .data![index].id,
                                                        title: snapshot
                                                            .data![index]
                                                            .title, user: widget.user, student: widget.student,skillsO: widget.skillsO,))),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: tPrimaryColor,
                                          side: const BorderSide(
                                            width: 1,
                                            color: Colors.white,
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        child: Text(
                                          "Apply Now",
                                          style: TextStyle(
                                            color: tLightColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
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
