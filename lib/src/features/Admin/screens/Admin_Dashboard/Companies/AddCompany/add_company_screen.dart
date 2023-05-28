import 'package:flutter/material.dart';

import '../../../../../../../responsive.dart';
import '../../../../../../constants/colors.dart';
import '../../components/admin_sidemenu.dart';
import '../companies_header.dart';
import 'add_company_form.dart';

class AddCompanyScreen extends StatelessWidget {
   AddCompanyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer:  AdminSideMenu(),
      body: SafeArea(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // We want this side menu only for large screen
        if (Responsive.isDesktop(context))
           Expanded(
            child: AdminSideMenu(),
          ),
        Expanded(
          // It takes 5/6 part of the screen
          flex: 5,
          child: SingleChildScrollView(
            primary: false,
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  // CompanyHeader(),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  AddCompanyForm()
                ]),
          ),
        ),
      ])),
    );
  }
}
