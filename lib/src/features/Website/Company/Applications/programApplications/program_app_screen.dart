import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:uptrain/src/features/Website/Company/Applications/programApplications/program_applications.dart';

import '../../../../../../responsive.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/size_config.dart';
import '../../../Admin/controllers/MenuAppController.dart';
import '../../components/company_side_menu.dart';
import '../applications.dart';
import '../applications_header.dart';

class ProgramApplicationsScreen extends StatelessWidget {
  Program program;
  Company company;
  ProgramApplicationsScreen(
      {super.key, required this.program, required this.company});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: CompanySideMenu(
        company: company,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ApplicationHeader(company: company),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SizedBox(
                        // width: 1300,
                        child: ProgramApplicationsPage(program: program,company: company,),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
