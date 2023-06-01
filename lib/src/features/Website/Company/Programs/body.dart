import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Website/Company/Programs/addProgram/add_program_screen.dart';
import 'package:uptrain/src/features/Website/Company/components/company_header.dart';
import 'package:uptrain/src/features/Website/Company/components/company_side_menu.dart';
import '../../../../../responsive.dart';
import '../../../../constants/size_config.dart';
import '../../Admin/screens/Admin_Dashboard/components/admin_sidemenu.dart';
import 'programs.dart';
import 'programs_header.dart';

class Body extends StatelessWidget {
  Company company;
  Body({
    super.key,
    required this.company
  });

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
                       CHeader(company: company,),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(45),
                            width: getProportionateScreenWidth(50),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                // shape: RoundedRectangleBorder(
                                // borderRadius: BorderRadius.circular(15)),
                                backgroundColor: tPrimaryColor,
                                side: const BorderSide(
                                  width: 1.5,
                                  color: tLightColor,
                                ),
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddProgramScreen(company: company,))),
                              child: const Text(
                                "Add Program",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Ubuntu'),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                       SizedBox(
                        width: 550,
                        child: ProgramsPage(company: company,),
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
