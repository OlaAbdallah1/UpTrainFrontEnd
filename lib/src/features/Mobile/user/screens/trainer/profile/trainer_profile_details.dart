import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_mail_app/open_mail_app.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/size_config.dart';
import '../../../models/trainer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../company/profile/company_profile_screen.dart';

class TrainerDetails extends StatefulWidget {
  final String trainer;
  const TrainerDetails({super.key, required this.trainer});

  @override
  State<TrainerDetails> createState() => _TrainerDetailsState();
}

class _TrainerDetailsState extends State<TrainerDetails> {
  late Trainer _trainer = Trainer(
      email: "",
      password: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      company: '');

  @override
  void initState() {
    super.initState();
    _loadTrainer();
  }

  Future<List<Trainer>> getTrainer(String trainerName) async {
    final response = await http
        .get(Uri.parse('http://$ip/api/getProgramTrainer/$trainerName'));

    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Trainer.fromJson(json)).toList();
  }

  void _loadTrainer() async {
    try {
      print(widget.trainer);
      final trainer = await getTrainer(widget.trainer);
      setState(() {
        _trainer = trainer.first;
      });
    } catch (e) {
      print('Error loading trainer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: _trainer == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(child: ImageFromUrl(imageUrl: _trainer.photo))
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    '${_trainer.first_name} ${_trainer.last_name}',
                    style: const TextStyle(
                        color: tPrimaryColor,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ]),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Text(
                  "Email:",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: getProportionateScreenHeight(22),
                    fontFamily: 'Ubuntu',
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      _trainer.email,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(16),
                      ),
                    )),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Text(
                  "Phone number:",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getProportionateScreenHeight(22),
                      fontFamily: 'Ubuntu',
                      color: tPrimaryColor),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  _trainer.phone,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(16),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Text(
                  "Working on:",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getProportionateScreenHeight(22),
                      fontFamily: 'Ubuntu',
                      color: tPrimaryColor),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyAccount(
                                  companyName: _trainer.company,
                                )));
                  },
                  child: Text(
                    _trainer.company,
                    style: TextStyle(
                        fontSize: getProportionateScreenHeight(16),
                        decoration: TextDecoration.underline,
                        color: tSecondaryColor),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                ElevatedButton(
                  child: Text(_trainer.email),
                  onPressed: () async {
                    EmailContent email = EmailContent(
                      to: [
                        _trainer.email,
                      ],
                    );

                    OpenMailAppResult result =
                        await OpenMailApp.composeNewEmailInMailApp(
                            nativePickerTitle: 'Select email app to compose',
                            emailContent: email);
                    if (!result.didOpen && !result.canOpen) {
                      showNoMailAppsDialog(context);
                    } else if (!result.didOpen && result.canOpen) {
                      showDialog(
                        context: context,
                        builder: (_) => MailAppPickerDialog(
                          mailApps: result.options,
                          emailContent: email,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
