import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Website/Trainer/Programs/PrpgramStudents/program_students.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_header.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_sideMaenu.dart';

import '../../../../../responsive.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_config.dart';
import '../../../../utils/theme/widget_themes/image_from_url.dart';
import '../../../Mobile/authentication/models/skills.dart';
import '../../../Mobile/user/models/trainer.dart';
import 'Tasks/AddTask/add_task_screen.dart';

class ProgramDetails extends StatelessWidget {
  final String title;
  final String image;
  final String details;
  final Trainer trainerr;
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
    required this.trainerr,
    required this.startDate,
    required this.endDate,
    required this.trainer,
    required this.programSkills,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        drawer: TrainerSideMenu(
          trainer: trainerr,
        ),
        body: SafeArea(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: TrainerSideMenu(
                trainer: trainerr,
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
                        THeader(trainer: trainerr),
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
                              const Text("Students",
                                  style: TextStyle(
                                      color: tPrimaryColor,
                                      fontSize: 20,
                                      fontFamily: 'Ubuntu',
                                      decoration: TextDecoration.underline)),
                              SizedBox(
                                  height: getProportionateScreenHeight(16)),
                              ProgramStudents(
                                  trainer: trainerr, programId: programId),
                              Row(
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(45),
                                    width: getProportionateScreenWidth(50),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        // shape: RoundedRectangleBorder(
                                        // borderRadius: BorderRadius.circular(15)),
                                        backgroundColor: tPrimaryColor,
                                        side: const BorderSide(
                                          width: 1.5,
                                          color: tLightColor,
                                        ),
                                      ),
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddTaskScreen(
                                                    programId: programId, trainer: trainerr,
                                                  ))),
                                      child: const Text(
                                        "Add Task",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: 'Ubuntu'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                            ],
                          ),
                        )
                      ])))
        ])));
  }
}
