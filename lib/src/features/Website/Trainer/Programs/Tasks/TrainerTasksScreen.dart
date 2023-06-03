import 'package:flutter/material.dart';
import 'package:uptrain/responsive.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/MyTasks/tasks.dart';
import 'package:uptrain/src/features/Website/Trainer/Programs/Tasks/tasks.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_header.dart';
import 'package:uptrain/src/features/Website/Trainer/components/trainer_sideMaenu.dart';

import '../../../../../constants/colors.dart';

class TrainerTasksScreen extends StatefulWidget {
  static String routeName = "/profile";
  final Map<String, dynamic> user;
  final Map<String, dynamic> trainer;

  const TrainerTasksScreen({
    required this.user,
    required this.trainer,
  });

  @override
  State<TrainerTasksScreen> createState() => _TrainerTasksScreenState();
}

class _TrainerTasksScreenState extends State<TrainerTasksScreen> {
  late Map<String, dynamic> combined = {};

  late Trainer _trainer = Trainer(
      id: 0,
      email: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      company: '');

  void combineData() {
    combined.addAll(widget.user);
    combined.addAll(widget.trainer);
    // print(combined);
    _trainer = Trainer.fromJson(combined);
  }

  @override
  void initState() {
    combineData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: TrainerSideMenu(
        trainer: _trainer,
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
                child: TrainerSideMenu(
                  trainer: _trainer,
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
                      THeader(
                        trainer: _trainer,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SizedBox(
                        width: 600,
                        child: TrainerTasks(
                          user: widget.user,
                          trainer: widget.trainer,
                        ),
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
