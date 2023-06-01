import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_header.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_sideMaenu.dart';
import '../../../../../responsive.dart';


class Body extends StatelessWidget {
  Trainer trainer;

  Body({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      // drawer: EmployeeSideMenu(employee : employee),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
               Expanded(
                
                // default flex = 1
                child: TrainerSideMenu(trainer : trainer),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      THeader(trainer: trainer),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const SizedBox(
                        width: 1100,
                        // child: Statistics(),
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
