import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/myAccount/my_account.dart';
import '../../../../../constants/colors.dart';
import '../../../../../utils/theme/widget_themes/image_from_url.dart';
import '../../../authentication/models/skills.dart';
import '../../../authentication/models/user.dart';
import 'profile_menu.dart';

class Body extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skills;
  const Body(
      {super.key,
      required this.user,
      required this.student,
      required this.skills});
  @override
  // ignore: library_private_types_in_public_api
  _BodyFormState createState() => _BodyFormState();
}

class _BodyFormState extends State<Body> {
  late Map<String, dynamic> combined = {};

  late User _user = User(
    id: 0,
    location: '',
    email: '',
    firstName: '',
    lastName: '',
    phone: '',
    field: '',
    photo: '',
    field_id: 0,
    location_id: 0
  );
  void combineData() {
    combined.addAll(widget.user);
    combined.addAll(widget.student);
    print(combined);
    _user = User.fromJson(combined);
    // print(_user);
  }

  @override
  void initState() {
    combineData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_user.photo);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Text(
            "Your Profile",
            style: headingStyle,
          ),
          // SizedBox(height: getProportionateScreenHeight(20)),
          ClipOval(
            child: ImageFromUrl(
              imageUrl: _user.photo,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${_user.firstName} ${_user.lastName}",
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: tPrimaryColor,
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyAccount(
                        user: widget.user,
                        student: widget.student,
                        skills: widget.skills,
                      )))
            },
          ),
          ProfileMenu(
            text: "Tasks",
            icon: "assets/icons/tasks-list-svgrepo-com.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Applications",
            icon: "assets/icons/apply-svgrepo-com.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}
