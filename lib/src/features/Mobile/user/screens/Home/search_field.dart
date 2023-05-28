import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:http/http.dart' as http;

import '../../../../../constants/colors.dart';
import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import '../../../authentication/models/skills.dart';
import '../../models/program_skills.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

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
          branch: '',
          details: '',
          trainer: ''),
      skills: []);

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
                .toList());
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
              element.program.company.contains(search.toLowerCase()))
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

  void filterEmployees(String query) {
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
    return Container(
      decoration: BoxDecoration(
        color: tSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) => print(value),
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
    );
  }
}
