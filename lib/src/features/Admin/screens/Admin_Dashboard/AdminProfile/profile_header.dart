import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Admin/models/Employee.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';
import 'package:http/http.dart' as http;

import '../../../../../../responsive.dart';
import '../../../../../constants/colors.dart';
import '../../../controllers/MenuAppController.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          const Text(
            "Admin Account",
            style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: tPrimaryColor),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        // const Expanded(child: SearchField()),
        ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  ProfileCard({
    Key? key,
  });

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  void initState() {
    setAdmin();
    super.initState();
  }

  static Employee _admin =
      Employee(email: '', first_name: '', last_name: '', phone: '', photo: '',field: '',location: '',field_id: 0);

  Future<List<Employee>> getAdmin() async {
    final response = await http.get(Uri.parse('http://$ip/api/getAdmin'));

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Employee.fromJson(json)).toList();
  }

  void setAdmin() async {
    final admin = await getAdmin();
    try {
      setState(() {
        _admin = admin.first;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: tSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/download.png',
              scale: 10,
            ),
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(
                "${_admin.first_name}  ${_admin.last_name}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ],
      ),
    );
  }
}
