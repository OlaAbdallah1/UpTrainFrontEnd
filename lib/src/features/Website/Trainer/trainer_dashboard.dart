import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Website/Trainer/Profile/profile_screen.dart';

import '../../../constants/size_config.dart';
import '../../Mobile/user/models/trainer.dart';

class TrainerDashboardScreen extends StatefulWidget {
  Map<String, dynamic> trainer;
  Map<String, dynamic> user;

  TrainerDashboardScreen({
    required this.trainer,
    required this.user,
    super.key,
  });

  @override
  State<TrainerDashboardScreen> createState() => _TrainerDashboardScreenState();
}

class _TrainerDashboardScreenState extends State<TrainerDashboardScreen> {
  Trainer _trainer = Trainer(
      email: '',
      id: 0,
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      company: '');

  late Map<String, dynamic> combined = {};

  void combineData() {
    combined.addAll(widget.user);
    combined.addAll(widget.trainer);
    print(combined);
    _trainer = Trainer.fromJson(combined);
  }

  @override
  void initState() {
    combineData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_trainer.email);
    SizeConfig().init(context);

    return Scaffold(
        body: TrainerProfilePage(
      trainer: _trainer,
    ));
  }
}
