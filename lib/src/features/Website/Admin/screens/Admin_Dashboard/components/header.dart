import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../global.dart' as global;

import '../../../../../../../responsive.dart';
import '../../../../../../constants/colors.dart';
import '../../../controllers/MenuAppController.dart';

class Header extends StatelessWidget {
  Header({
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
            "Dashboard",
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

  static Employee _admin = Employee(
      email: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      field: '',
      location: '',
      field_id: 0);

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

  void logout() async {
    try {
      var res = await http.post(
        Uri.parse("http://$ip/api/logout"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      print("hiiii");
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
          PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Logout'),
                      ),
                    ),
                  ],
              child: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white),
                  onPressed: () {
                    // Show the dropdown menu
                    final RenderBox button =
                        context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Overlay.of(context)
                        .context
                        .findRenderObject() as RenderBox;
                    final RelativeRect position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(Offset.zero, ancestor: overlay),
                        button.localToGlobal(
                            button.size.bottomRight(Offset.zero),
                            ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                    );
                    showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(position.left,
                          position.top + 50, position.right, position.bottom
                          // Adjust the value to change the menu's vertical position
                          ),
                      items: <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: ListTile(
                            leading: const Icon(Icons.exit_to_app),
                            title: const Text('Logout'),
                          ),
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: tSecondaryColor,
        // filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: tPrimaryColor, width: 2.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: tSecondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
