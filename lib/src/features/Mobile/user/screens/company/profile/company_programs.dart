import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/connections.dart';
import '../../../../../../constants/size_config.dart';
import '../../../models/program.dart';
import 'package:http/http.dart' as http;

import '../../Program/Apply/application_screen.dart';
import '../../Program/Program_Details/program_screen.dart';

class CompanyPrograms extends StatefulWidget {
  final String companyName;

  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;
  const CompanyPrograms(
      {super.key,
      required this.companyName,
      required this.user,
      required this.student,
      required this.skillsO});

  @override
  State<CompanyPrograms> createState() => _CompanyProgramsState();
}

class _CompanyProgramsState extends State<CompanyPrograms> {
  @override
  void initState() {
    super.initState();
  }

  List<Program> companyPrograms = [];

  Future<List<Program>> fetchCompanyPrograms(String companyName) async {
    final response = await http
        .get(Uri.parse('http://$ip/api/getCompanyPrograms/$companyName'));

    var responseData = json.decode(response.body);
    print(responseData);
    if (response.statusCode == 201) {
      for (Map program in responseData) {
        companyPrograms.add(Program.fromJson(program));
      }
      return companyPrograms;
    } else {
      return companyPrograms;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: getProportionateScreenHeight(160),
        child: ListView(scrollDirection: Axis.horizontal, children: [
          Card(
            child: FutureBuilder(
              future: fetchCompanyPrograms(widget.companyName),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(snapshot
                                                          .data![index].branch.name),
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
                                                            color:
                                                                Colors.black87,
                                                            fontFamily:
                                                                'Ubuntu',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
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
                                                        title: snapshot
                                                            .data![index].title,
                                                        details: snapshot
                                                            .data![index]
                                                            .details,
                                                        image: snapshot
                                                            .data![index].image,
                                                        company: snapshot
                                                            .data![index]
                                                            .company,
                                                        startDate: snapshot
                                                            .data![index]
                                                            .start_date,
                                                        endDate: snapshot
                                                            .data![index]
                                                            .end_date,
                                                        trainer: snapshot
                                                            .data![index]
                                                            .trainer,
                                                        programSkills: [],
                                                        student: widget.student,
                                                        user: widget.user,
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
                                                          .data![index].title,
                                                      student: widget.student,
                                                      user: widget.user,
                                                      skillsO: widget.skillsO,
                                                    ))),
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
