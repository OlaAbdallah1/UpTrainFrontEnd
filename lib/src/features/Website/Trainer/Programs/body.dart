import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Website/Company/Programs/addProgram/add_program_screen.dart';
import 'package:uptrain/src/features/Website/Company/components/company_header.dart';
import 'package:uptrain/src/features/Website/Company/components/company_side_menu.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_header.dart';
import '../../../../../responsive.dart';
import '../../../../constants/size_config.dart';
import '../../Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import '../components/trainer_sideMaenu.dart';
import 'programs.dart';
import 'programs_header.dart';

class Body extends StatelessWidget {
  Trainer trainer;
  Body({
    super.key,
    required this.trainer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: TrainerSideMenu(
        trainer: trainer,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: TrainerSideMenu(
        trainer: trainer,
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
                       THeader(trainer: trainer,),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                     
                      const SizedBox(
                        height: defaultPadding,
                      ),
                       SizedBox(
                        width: 600,
                        child: ProgramsPage(trainer: trainer,),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
