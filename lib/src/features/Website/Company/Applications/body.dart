import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Website/Company/Applications/applications.dart';

import '../../../../../responsive.dart';
import '../../../../constants/size_config.dart';
import '../../../Mobile/user/models/company.dart';
import '../../Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import '../Programs/addProgram/add_program_screen.dart';
import '../components/company_header.dart';
import '../components/company_side_menu.dart';
import 'applications_header.dart';

class Body extends StatelessWidget {
  Company company;
  Body({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
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
                    children: [
                      ApplicationHeader(company: company),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      
                      ApplicationsPage(company: company)
                     
                      
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
