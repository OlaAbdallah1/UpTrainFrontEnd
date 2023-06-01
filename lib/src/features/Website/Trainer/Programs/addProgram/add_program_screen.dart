import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import 'package:uptrain/src/features/Website/Company/components/company_header.dart';
import 'package:uptrain/src/features/Website/Company/components/company_side_menu.dart';

import '../../../../../../responsive.dart';

import '../../../../../constants/colors.dart';
import '../programs_header.dart';
import 'add_program_form.dart';

class AddProgramScreen extends StatelessWidget {
  Company company;
   AddProgramScreen({super.key,required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: CompanySideMenu(company: company),
      body: SafeArea(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // We want this side menu only for large screen
        if (Responsive.isDesktop(context))
          Expanded(
            // default flex = 1
            // and it takes 1/6 part of the screen
            child: CompanySideMenu(company: company),
          ),
        Expanded(
          // It takes 5/6 part of the screen
          flex: 5,
          child: SingleChildScrollView(
            primary: false,
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  CHeader(company: company,),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  AddProgramForm(company:company)
                ]),
          ),
        ),
      ])),
    );
  }
}
