import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import 'package:uptrain/src/features/Website/Company/components/company_header.dart';
import 'package:uptrain/src/features/Website/Company/components/company_side_menu.dart';
import 'package:uptrain/src/features/Website/Trainer/Programs/Tasks/AddTask/add_task_form.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_header.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_sideMaenu.dart';

import '../../../../../../../responsive.dart';
import '../../../../../../constants/colors.dart';

class AddTaskScreen extends StatelessWidget {
  int programId;
  Trainer trainer;
  AddTaskScreen({super.key, required this.programId, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: TrainerSideMenu(trainer: trainer),
      body: SafeArea(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // We want this side menu only for large screen
        if (Responsive.isDesktop(context))
          Expanded(
            // default flex = 1
            // and it takes 1/6 part of the screen
            child: TrainerSideMenu(trainer: trainer),
          ),
        Expanded(
          // It takes 5/6 part of the screen
          flex: 5,
          child: SingleChildScrollView(
            primary: false,
            padding: EdgeInsets.all(defaultPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              THeader(
                trainer: trainer,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              AddTaskForm(programId: programId, trainerId: trainer.id)
            ]),
          ),
        ),
      ])),
    );
  }
}
