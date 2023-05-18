import 'package:flutter/material.dart';

import '../../../../../../../responsive.dart';
import '../../../../../../constants/colors.dart';
import '../companies_header.dart';
import '../../../main/components/side_menu.dart';
import 'add_company_form.dart';

class AddCompanyScreen extends StatelessWidget {
  const AddCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // We want this side menu only for large screen
        if (Responsive.isDesktop(context))
          const Expanded(
            child: SideMenu(),
          ),
        Expanded(
          // It takes 5/6 part of the screen
          flex: 5,
          child: SingleChildScrollView(
            primary: false,
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
