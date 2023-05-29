import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import '../../../../../responsive.dart';
import 'components/company_header.dart';
import 'components/company_side_menu.dart';

class Body extends StatelessWidget {
  Company company;

  Body({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    print(company.email);
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
                child: CompanySideMenu(company : company),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CHeader(company: company),
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
