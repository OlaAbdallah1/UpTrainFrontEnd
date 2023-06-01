import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Website/Company/Profile/profile_screen.dart';

import '../../../constants/size_config.dart';
import '../../Mobile/user/models/company.dart';

class CompanyDashboardScreen extends StatefulWidget {
  Map<String, dynamic> company;

  CompanyDashboardScreen({
    required this.company,
    super.key,
  });

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  Company _company = Company(
    id: 0,
    email: '',
    description: '',
    location: '',
    name: '',
    phone: '',
    photo: '',
    website: '',
  );

  @override
  void initState() {
    _company = Company.fromJson(widget.company);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_company.email);
    SizeConfig().init(context);

    return Scaffold(
      body: CompanyProfilePage(
        company: _company,
      ),
    );
  }
}
