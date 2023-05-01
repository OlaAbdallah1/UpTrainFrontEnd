import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Admin/screens/Fields_Admins/Admins_header.dart';

import '../../../../../../responsive.dart';
import '../../../../../constants/colors.dart';
import '../../../../../utils/background.dart';
import '../../main/components/side_menu.dart';
import 'add_admin_form.dart';

class AddAdminScreen extends StatelessWidget {
  const AddAdminScreen({super.key});

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
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  AdminHeader(),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  AddAdminForm()
                ]),
          ),
        ),
      ])),
    );
  }
}
