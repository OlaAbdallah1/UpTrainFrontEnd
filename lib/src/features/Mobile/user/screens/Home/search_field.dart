import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/branch.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Program/Apply/application_screen.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Program/Program_Details/program_screen.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import '../../../authentication/models/skills.dart';
import '../../models/program_skills.dart';

class SearchField extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  late List<Skill> skills;
  SearchField(
      {super.key,
      required this.user,
      required this.student,
      required this.skills});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  List<Program> filteredPrograms = [];
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
  Future<Iterable<ProgramSkills>> fetchPrograms(String search) async {
    final response = await http.get(Uri.parse('http://$ip/api/getPrograms'));
    final data = json.decode(response.body);
    setState(() {
      for (Map program in data) {
        //     print(program);
        programSkills = ProgramSkills(
          program: Program.fromJson(program),
          skills: (program['skill'] as List<dynamic>)
              .map((skillJson) => Skill.fromJson(skillJson))
              .toList(),
        );

        programsData.add(programSkills);
      }
    });

    if (search.isEmpty) {
      return programsData.toList();
    } else {
      print(programsData
          .where((element) =>
              element.program.title.contains(search.toLowerCase()) ||
              element.program.company.contains(search.toLowerCase()))
          .toList());
      return programsData
          .where((element) =>
              element.program.title.contains(search.toLowerCase()) ||
              element.program.company.contains(search.toLowerCase()) ||
              element.program.branch.name.contains(search.toLowerCase()) ||
              element.program.trainer.first_name
                  .contains(search.toLowerCase()) ||
              element.program.trainer.last_name.contains(search.toLowerCase()))
          .toList();
    }

    // var responseData = json.decode(response.body);
    // // programSkills.skills = responseData['skill'];

    // if (response.statusCode == 201) {
    //   for (Map program in responseData) {
    //     print(program);
    //     programSkills = ProgramSkills(
    //         program: Program.fromJson(program),
    //         skills: (program['skill'] as List<dynamic>)
    //             .map((skillJson) => Skill.fromJson(skillJson))
    //             .toList());
    //     // programSkills.skills =
    //     // print(programSkills.skills);
    //     programsData.add(programSkills);
    //   }
    //   return programsData;
    // } else {
    //   return programsData;
    // }
  }

  void filterPragrams(String query) {
    setState(() {
      // Filter the companies based on the search query
      filteredPrograms = programsData
          .where((program) {
            final programName = '${program.program.title}'.toLowerCase();
            return programName.contains(query.toLowerCase());
          })
          .cast<Program>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Column(children: [
              TextField(
                onChanged: (value) {
                  filterPragrams(value);
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenWidth(11)),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "Search program/company/branch",
                    prefixIcon: Icon(Icons.search)),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 545,
                  child: buildProgram(programsData),
                ),
              )
            ])));
  }

  Widget buildProgram(List<ProgramSkills> programs) => ListView.builder(
        itemCount: programs.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final program = programs[index].program;
          final skills = programs[index].skills;
          return Card(
            elevation: 40,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProgramDetailsScreen(
                              company: program.company,
                              title: program.title,
                              details: program.details,
                              endDate: program.end_date,
                              startDate: program.start_date,
                              skillsO: widget.skills,
                              image: program.image,
                              programId: program.id,
                              programSkills: skills,
                              student: widget.student,
                              user: widget.user,
                              trainer: program.trainer,
                            )));
              },
              child: Container(
                height: 220,
                // color: Colors.purple.withOpacity(0.15),
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
                                    "${program.title}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(16),
                                        color: tPrimaryColor,
                                        // fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(program.branch.name)),
                              ListTile(
                                title: Text(
                                  "By ${program.company}",
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16),
                                      color: tPrimaryColor,
                                      // fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.normal),
                                ),
                                subtitle: Text(
                                  " ${program.start_date} \t-\t ${program.end_date}",
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenHeight(13),
                                      color: Colors.black87,
                                      fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.normal),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProgramDetailsScreen(
                                          programId: program.id,
                                          title: program.title,
                                          details: program.details,
                                          image: program.image,
                                          company: program.company,
                                          startDate: program.start_date,
                                          endDate: program.end_date,
                                          trainer: program.trainer,
                                          programSkills: skills,
                                          user: widget.user,
                                          student: widget.student,
                                          skillsO: widget.skills,
                                        ))),
                            child: Text(
                              "Show Details ",
                              style: TextStyle(
                                  color: tPrimaryColor,
                                  fontSize: getProportionateScreenHeight(16),
                                  decoration: TextDecoration.underline),
                            )),
                        OutlinedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApplicationScreen(
                                        title: program.title,
                                        programId: program.id,
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
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            "Apply Now",
                            style: TextStyle(
                                color: tLightColor,
                                fontSize: getProportionateScreenHeight(16)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
