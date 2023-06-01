import 'package:flutter/material.dart';

import '../../../constants/size_config.dart';
import '../../Mobile/user/models/company.dart';
import '../../Mobile/user/models/trainer.dart';
import 'body.dart';

class TrainerDashboardScreen extends StatefulWidget {
  Map<String, dynamic> trainer;

  TrainerDashboardScreen({
    required this.trainer,
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

  @override
  void initState() {
    _trainer = Trainer.fromJson(widget.trainer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_trainer.email);
    SizeConfig().init(context);

    return Scaffold(
      body: Body(
        trainer: _trainer,
      ),
    );
  }
}
