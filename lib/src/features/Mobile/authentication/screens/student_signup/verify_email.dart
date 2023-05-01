import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import '../../../../../constants/text.dart';
import '../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../fierbase_exceptions.dart';
import '../../models/user.dart';

class VerifyEmailScreen extends StatelessWidget {
  final User user;
  const VerifyEmailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              Text("Verify your Email", style: headingStyle),
              Text(
                "Please enter the code you recieved to complete your registration",
                textAlign: TextAlign.center,
                style: bodyTextStyle,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              VerifyEmailForm(user: user),
            ],
          ),
        ),
      ),
    ));
  }
}

class VerifyEmailForm extends StatefulWidget {
  late final User user;
  VerifyEmailForm({required this.user});

  @override
  _VerifyEmailFormState createState() => _VerifyEmailFormState();
}

class _VerifyEmailFormState extends State<VerifyEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final verifyController = TextEditingController();

  @override
  void dispose() {
    verifyController.dispose();
    super.dispose();
  }

  String email = '';
  String data = '';
  String errorImg = "assets/icons/white.svg";
  String codeError = '';

  @override
  Widget build(BuildContext context) {
    print(widget.user.toJson());
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: verifyController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  errorImg = 'assets/icons/white.svg';
                  data = '';
                });
              }
              // user.email = value;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.numbers,
                color: tPrimaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              labelText: 'Enter the code',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),

          Row(
            children: [
              SvgPicture.asset(
                errorImg,
                height: getProportionateScreenWidth(14),
                width: getProportionateScreenWidth(14),
              ),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              Text(data),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextButton(
            onPressed: () {},
            child: const Text("Resend Code"),
          ),

          DefaultButton(
            text: "Confirm",
            press: () async {
              if (_formKey.currentState!.validate()) {
                var response = await http.post(
                  Uri.parse("http://$ip:8000/api/verify"),
                  headers: <String, String>{
                    'Context-Type': 'application/json;charSet=UTF-8'
                  },
                  body: json.encode(widget.user.email),
                );
                if (response.statusCode == 201) {
                  print("body : ${response.body}");
                  print("json : ${json.decode(response.body)}");
                } else {
                  print("final error : jaym " + response.body);
                }

                // print(json.encode(widget.user.toJson()));
                print(response.statusCode);

                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Welcome'),
                    content: const Text("Your account created successfully"),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: tPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen())),
                        child: Text('Login',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(14),
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                );
                if (response.statusCode == 400) {
                  setState(() {
                    codeError = "Your code does not match the right one";
                  });

                  return;
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                }
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          // NoAccountText(),
        ],
      ),
    );
  }
}
