import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/user/models/branch.dart';
import 'package:uptrain/src/features/Mobile/user/models/program_skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/size_config.dart';
import '../../../Mobile/authentication/models/skills.dart';
import '../../../Mobile/user/models/program.dart';
import 'program_details.dart';

class ProgramsPage extends StatefulWidget {
  Trainer trainer;
  ProgramsPage({super.key, required this.trainer});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  ProgramSkills programSkills = ProgramSkills(
    program: Program(
        id: 0,
        // user_id: 0,
        title: '',
        image: '',
        company: '',
        start_date: '',
        end_date: '',
        branch: Branch(id: 0, name: ''),
        details: '',
        trainer: Trainer(
            id: 0,
            email: '',
            first_name: '',
            last_name: '',
            phone: '',
            photo: '',
            company: '')),
    skills: [],
  );
  List<ProgramSkills> programsData = [];

  List skills = [];
  Future<List<ProgramSkills>> fetchPrograms() async {
    final response = await http.get(
        Uri.parse('http://$ip/api/getTrainerPrograms/${widget.trainer.id}'));

    var responseData = json.decode(response.body);
    // programSkills.skills = responseData['skill'];

    if (response.statusCode == 201) {
      for (Map program in responseData) {
        programSkills = ProgramSkills(
          program: Program.fromJson(program),
          skills: (program['skill'] as List<dynamic>)
              .map((skillJson) => Skill.fromJson(skillJson))
              .toList(),
        );

        programsData.add(programSkills);
      }
      return programsData;
    }
    return programsData;
  }

  late Future<List<ProgramSkills>> _futurePrograms = fetchPrograms();

  @override
  void initState() {
    super.initState();
    _futurePrograms = fetchPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          FutureBuilder(
            future: _futurePrograms,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                        getProportionateScreenHeight(450),
                    children: List.generate(snapshot.data!.length, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(2),
                            vertical: getProportionateScreenHeight(2)),
                        child: Container(
                          // height: getProportionateScreenHeight(150),
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
                                                  "${snapshot.data![index].program.title}",
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
                                                subtitle: Text(snapshot
                                                    .data![index]
                                                    .program
                                                    .branch
                                                    .name)),
                                            ListTile(
                                              title: Text(
                                                " ${snapshot.data![index].program.start_date} \t-\t ${snapshot.data![index].program.end_date}",
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            13),
                                                    color: Colors.black87,
                                                    fontFamily: 'Ubuntu',
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProgramDetails(
                                                          programId: snapshot
                                                              .data![index]
                                                              .program
                                                              .id,
                                                          title: snapshot
                                                              .data![index]
                                                              .program
                                                              .title,
                                                          details: snapshot
                                                              .data![index]
                                                              .program
                                                              .details,
                                                          image: snapshot
                                                              .data![index]
                                                              .program
                                                              .image,
                                                          trainerr:
                                                              widget.trainer,
                                                          startDate: snapshot
                                                              .data![index]
                                                              .program
                                                              .start_date,
                                                          endDate: snapshot
                                                              .data![index]
                                                              .program
                                                              .end_date,
                                                          trainer:
                                                              '${snapshot.data![index].program.trainer.first_name} ${snapshot.data![index].program.trainer.last_name}',
                                                          programSkills:
                                                              snapshot
                                                                  .data![index]
                                                                  .skills,
                                                        ))),
                                            child: Text(
                                              "Show Details ",
                                              style: TextStyle(
                                                  color: tPrimaryColor,
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          16),
                                                  decoration:
                                                      TextDecoration.underline),
                                            )),
                                      ]),
                                ]),
                          ),
                        ),
                      );
                    }));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
