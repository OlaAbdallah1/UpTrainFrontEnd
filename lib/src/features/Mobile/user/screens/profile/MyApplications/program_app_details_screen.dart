import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/MyApplications/program_app_details.dart';
import 'package:uptrain/src/utils/theme/widget_themes/appbar.dart';

class ProgramAppScreen extends StatelessWidget {
  int program_id;
   ProgramAppScreen({super.key,required this.program_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ProgramAppDetails(program_id: program_id,));
  }
}
