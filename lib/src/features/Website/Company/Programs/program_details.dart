import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';

import '../../../../../responsive.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_config.dart';
import '../../../../utils/theme/widget_themes/image_from_url.dart';
import '../../../Mobile/authentication/models/skills.dart';
import '../components/company_header.dart';
import '../components/company_side_menu.dart';

class ProgramDetails extends StatelessWidget {
  final String title;
  final String image;
  final String details;
  final Company company;
  final String startDate;
  final String endDate;
  final String trainer;
  final int programId;

  final List<Skill> programSkills;

  ProgramDetails({
    required this.programId,
    required this.title,
    required this.image,
    required this.details,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.trainer,
    required this.programSkills,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        drawer: CompanySideMenu(
          company: company,
        ),
        body: SafeArea(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: CompanySideMenu(
                company: company,
              ),
            ),
          Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CHeader(
                          company: company,
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: defaultPadding * 1.5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$title Program',
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(24),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Ubuntu',
                                        color: tPrimaryColor),
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            color: tPrimaryColor,
                                            onPressed: () => {},
                                          ),
                                          Text(
                                            'Edit Program',
                                            style: TextStyle(
                                                color: tSecondaryColor,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        16),
                                                decoration:
                                                    TextDecoration.underline),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(16)),
                              const Text(
                                "Program Details: ",
                                style: TextStyle(
                                    color: tPrimaryColor,
                                    fontSize: 20,
                                    fontFamily: 'Ubuntu',
                                    decoration: TextDecoration.underline),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(10)),
                              Text(
                                details.splitMapJoin('.'),
                                style: TextStyle(
                                  fontSize: getProportionateScreenHeight(16),
                                ),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(16)),
                              const Text("Duration",
                                  style: TextStyle(
                                      color: tPrimaryColor,
                                      fontSize: 20,
                                      fontFamily: 'Ubuntu',
                                      decoration: TextDecoration.underline)),
                              SizedBox(
                                  height: getProportionateScreenHeight(10)),
                              Text(
                                "$startDate - $endDate",
                                style: TextStyle(
                                  fontSize: getProportionateScreenHeight(18),
                                ),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(16)),
                              const Text("Requirments Skills",
                                  style: TextStyle(
                                      color: tPrimaryColor,
                                      fontSize: 20,
                                      fontFamily: 'Ubuntu',
                                      decoration: TextDecoration.underline)),
                              SizedBox(
                                  height: getProportionateScreenHeight(10)),
                              SizedBox(
                                width: getProportionateScreenWidth(200),
                                child: Wrap(
                                  spacing: 6,
                                  children: programSkills
                                      .map((skill) => Text(
                                            skill.name,
                                            style: TextStyle(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                color: Colors.black,
                                                fontSize: 20),
                                          ))
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(16)),
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
                                  TextButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => TrainerAccount(
                                      //               trainer: trainer,

                                      //             )));
                                    },
                                    child: Text(
                                      trainer,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize:
                                              getProportionateScreenHeight(18),
                                          fontFamily: 'Ubuntu',
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ])))
        ])));
  }
}
