import 'package:flutter/material.dart';

import '../../../../../../responsive.dart';

import '../../../../constants/colors.dart';
import '../../../Admin/screens/main/components/side_menu.dart';
import '../programs_header.dart';
import 'add_program_form.dart';

class AddProgramScreen extends StatelessWidget {
  const AddProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // We want this side menu only for large screen
        if (Responsive.isDesktop(context))
          Expanded(
            // default flex = 1
            // and it takes 1/6 part of the screen
            child: SideMenu(),
          ),
        Expanded(
          // It takes 5/6 part of the screen
          flex: 5,
          child: SingleChildScrollView(
            primary: false,
            padding:  EdgeInsets.all(defaultPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ProgramHeader(),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  AddProgramForm()
                ]),
          ),
        ),
      ])),
    );
  }
}
