import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/branch.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:uptrain/src/features/Mobile/user/models/program_skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Mobile/user/screens/company/profile/company_profile_screen.dart';
import 'package:uptrain/src/utils/theme/widget_themes/appbar.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/connections.dart';
import '../../../../../../constants/size_config.dart';

class ProgramAppDetails extends StatefulWidget {
  int program_id;
  ProgramAppDetails({super.key, required this.program_id});

  @override
  State<ProgramAppDetails> createState() => _ProgramAppDetailsState();
}

class _ProgramAppDetailsState extends State<ProgramAppDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProgram();
  }

  ProgramSkills programSkill = ProgramSkills(
      program: Program(
          id: 0,
          title: '',
          image: '',
          company: '',
          start_date: '',
          end_date: '',
          branch: Branch(id: 0, name: ''),
          details: '',
          trainer: Trainer(
              email: '',
              id: 0,
              first_name: '',
              last_name: '',
              phone: '',
              photo: '',
              company: '')),
      skills: []);

  // late Future<ProgramSkills> programs;

  Future<ProgramSkills> getProgram() async {
    final response = await http
        .get(Uri.parse('http://$ip/api/getProgram/${widget.program_id}'));

    var responseData = json.decode(response.body);
    // programSkills.skills = responseData['skill'];

    if (response.statusCode == 201) {
      for (Map program in responseData) {
        // print(program);
        programSkill = ProgramSkills(
          program: Program.fromJson(program),
          skills: (program['skill'] as List<dynamic>)
              .map((skillJson) => Skill.fromJson(skillJson))
              .toList(),
        );
      }
    }

    return programSkill;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      body:    
    SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ClipOval(
              //   child: ImageFromUrl(imageUrl: programSkill.program.image),
              // ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Text(
                programSkill.program.company,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: getProportionateScreenHeight(24),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: tPrimaryColor),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Text(
                programSkill.program.title,
                style: TextStyle(
                    fontSize: getProportionateScreenHeight(24),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: tPrimaryColor),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text(
                "Program Details: ",
                style: TextStyle(
                    color: tPrimaryColor,
                    fontSize: 20,
                    fontFamily: 'Ubuntu',
                    decoration: TextDecoration.underline),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                programSkill.program.details,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(16),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text("Duration",
                  style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      decoration: TextDecoration.underline)),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "${programSkill.program.start_date} - ${programSkill.program.end_date}",
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(18),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text("Requirments Skills",
                  style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      decoration: TextDecoration.underline)),
              SizedBox(height: getProportionateScreenHeight(10)),
              SizedBox(
                width: getProportionateScreenWidth(200),
                child: Wrap(
                  spacing: 4,
                  children: programSkill.skills
                      .map((skill) => Text(
                            skill.name,
                            style: TextStyle(
                                backgroundColor: Colors.grey[300],
                                color: Colors.black,
                                fontSize: 20),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text("Trainer",
                  style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      decoration: TextDecoration.underline)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${programSkill.program.trainer.first_name} ${programSkill.program.trainer.last_name}',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: getProportionateScreenHeight(18),
                        fontFamily: 'Ubuntu',
                        color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        )) ,
    );
  }
}
