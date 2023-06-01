import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';
import '../../../../../../global.dart' as global;

import '../../../../../../responsive.dart';
import '../../../../constants/colors.dart';
import '../../../Mobile/user/models/trainer.dart';
import '../../Admin/controllers/MenuAppController.dart';
import '../../../Mobile/user/models/trainer.dart';

class THeader extends StatelessWidget {
  Trainer trainer;

  THeader({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    print(trainer.email);
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${trainer.first_name} ',
                style: const TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: tPrimaryColor),
              ),
              Text(
                '${trainer.company}',
                style: const TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: tPrimaryColor),
              ),
            ],
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        ProfileCard(
          trainer: trainer,
        )
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  Trainer trainer;
  ProfileCard({
    required this.trainer,
    Key? key,
  });

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  void logout() async {
    try {
      var res = await http.post(
        Uri.parse("http://$ip/api/logout"),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': global.token
        },
      );
      if (res.statusCode == 201) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print('failed to logout: ');
      }
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
          CircleAvatar(
            radius: 20,
            child: Image.asset('assets/images/${widget.trainer.photo}'),
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(
                '${widget.trainer.first_name}',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  logout();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout'),
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
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: ListTile(
                            leading: Icon(Icons.exit_to_app),
                            title: Text('Logout'),
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
