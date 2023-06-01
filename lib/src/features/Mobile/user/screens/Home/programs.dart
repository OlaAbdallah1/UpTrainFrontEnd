// ignore_for_file: no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/user/models/branch.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:uptrain/src/features/Mobile/user/models/program_skills.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Program/Apply/application_screen.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/size_config.dart';
import 'package:http/http.dart' as http;

import '../../../authentication/models/skills.dart';
import '../../models/trainer.dart';
import '../Program/Program_Details/program_screen.dart';
import 'recommended.dart';
import 'search_field.dart';
// Our Category List need StateFullWidget
// I can use Provider on it, Then we dont need StatefulWidget

class Programs extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  late List<Skill> skills;

  Programs(
      {super.key,
      required this.user,
      required this.student,
      required this.skills});
  @override
  // ignore: library_private_types_in_public_api
  _ProgramsState createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  _ProgramsState();

  @override
  void initState() {
    fetchBranches();
    super.initState();
  }

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
        trainer: Trainer(id:0, email: '', first_name: '', last_name: '', phone: '', photo: '', company: '')
      ),
      skills: [],
      );

  String _selectedBranch = 'All';

  Future<List<Branch>> fetchBranches() async {
    List<Branch> branchesDate = [
      Branch(id:0, name: 'All'),
    ];

    String url = "http://$ip/api/getbranches/${widget.student['field_id']}";
    final response = await http.get(Uri.parse(url));
    // print(response.body);
    var responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      for (Map branch in responseData) {
        branchesDate.add(Branch.fromJson(branch));
      }

      return branchesDate;
    } else {
      return branchesDate;
    }
  }

  List<ProgramSkills> programsData = [];

  List skills = [];
  Future<List<ProgramSkills>> fetchPrograms() async {
    if (_selectedBranch == 'All') {
      final response = await http.get(Uri.parse(
          'http://$ip/api/getPrograms/${widget.student['field_id']}'));

      var responseData = json.decode(response.body);
      // programSkills.skills = responseData['skill'];

      if (response.statusCode == 201) {
        for (Map program in responseData) {
          // print(program);
          programSkills = ProgramSkills(
              program: Program.fromJson(program),
              skills: (program['skill'] as List<dynamic>)
                  .map((skillJson) => Skill.fromJson(skillJson))
                  .toList(),
            
              );

          programsData.add(programSkills);
        }
        return programsData;
      } else {
        return programsData;
      }
    } else {
      final response = await http.get(Uri.parse(
          'http://$ip/api/getPrograms/${widget.student['field_id']}'));
      var responseData = jsonDecode(response.body);
      // print(responseData);

      if (response.statusCode == 201) {
        // final List<dynamic> data = json.decode(response.body);
        // print(data);
        return programsData
            .where((element) => element.program.branch == _selectedBranch)
            .toList();
        // .map((json) => Program.fromJson(json))
        // .where((item) => item.branch == _selectedBranch)
        // .toList();
      }
    }
    throw Exception('Failed to fetch items');
  }

  late Program programTrainer;

  Future<Program> fetchTrainerProgram() async {
    final response = await http.get(Uri.parse(
        'http://$ip/api/getProgramTrainer/${programSkills.program.id}'));
    var responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      for (Map program in responseData) {
        // print(program);
       
      }
      return programTrainer;
    } else {
      return programTrainer;
    }
  }

  // By default first one is selected
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SearchField(),
        SizedBox(height: getProportionateScreenHeight(10)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder(
              future: fetchBranches(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print(_categorizedPrograms.toString());
                  return SizedBox(
                      height: getProportionateScreenHeight(30),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  _selectedBranch = snapshot.data![index].name;
                                  print("selected branch ${_selectedBranch}");
                                });
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    left: getProportionateScreenWidth(2)),
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenHeight(18),
                                  vertical: getProportionateScreenWidth(4),
                                ),
                                decoration: BoxDecoration(
                                    color: selectedIndex == index
                                        ? Color(0xFFEFF3EE)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  snapshot.data![index].name,
                                  style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.bold,
                                    color: selectedIndex == index
                                        ? tPrimaryColor
                                        : Color(0xFFC2C2B5),
                                  ),
                                ),
                              ),
                            );
                          }));
                }
                print("No branches");
                return const CircleAvatar();
              }),
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        Row(
          children: [
            SizedBox(
              width: getProportionateScreenWidth(12),
            ),
            Text(
              "Recommended for you ",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: getProportionateScreenHeight(18),
                  color: tPrimaryColor,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            )
          ],
        ),
        // SizedBox(
        //     height: getProportionateScreenHeight(240),
        //     child: Recommended(
        //       user: widget.user,
        //       student: widget.student,
        //       skillsO: widget.skills,
        //     )),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(12),
              ),
              Text(
                '$_selectedBranch Programs',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: getProportionateScreenHeight(22),
                    color: tPrimaryColor,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(10),
          )
        ]),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: fetchPrograms(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(_selectedBranch);
                if (snapshot.data!.isEmpty) {
                  return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(2),
                          vertical: getProportionateScreenHeight(2)),
                      child: Container(
                          height: getProportionateScreenHeight(120),
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
                              // color: tLightColor,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.01,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                              child: Column(children: [
                                            ListTile(
                                              title: Text(
                                                "No ${_selectedBranch} training programs yet!",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            16),
                                                    color: tPrimaryColor,
                                                    // fontFamily: 'Ubuntu',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "You may have interested in ",
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
                                                TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      "Recommended",
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize:
                                                              getProportionateScreenHeight(
                                                                  16)),
                                                    ))
                                              ],
                                            ),
                                          ]))
                                        ])
                                  ]))));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(2),
                              vertical: getProportionateScreenHeight(2)),
                          child: Container(
                            height: getProportionateScreenHeight(206),
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
                                                    .branch.name)),
                                            ListTile(
                                              title: Text(
                                                "By ${snapshot.data![index].program.company}",
                                                // overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            16),
                                                    color: tPrimaryColor,
                                                    // fontFamily: 'Ubuntu',
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              subtitle: Text(
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
                                                        company: snapshot
                                                            .data![index]
                                                            .program
                                                            .company,
                                                        startDate: snapshot
                                                            .data![index]
                                                            .program
                                                            .start_date,
                                                        endDate: snapshot
                                                            .data![index]
                                                            .program
                                                            .end_date,
                                                        trainer:snapshot.data![index].program.trainer,
                                                        programSkills: snapshot
                                                            .data![index]
                                                            .skills,
                                                        user: widget.user,
                                                        student: widget.student,
                                                        skillsO: widget.skills,
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
                                      OutlinedButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ApplicationScreen(
                                                      title: snapshot
                                                          .data![index]
                                                          .program
                                                          .title,
                                                      programId: snapshot
                                                          .data![index]
                                                          .program
                                                          .id,
                                                      user: widget.user,
                                                      student: widget.student,
                                                      skillsO: widget.skills,
                                                    ))),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: tPrimaryColor,
                                          side: const BorderSide(
                                            width: 1.5,
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
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      16)),
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
                }
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
      ],
    ));
  }
}
