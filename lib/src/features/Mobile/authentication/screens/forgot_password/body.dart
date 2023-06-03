import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:purple/user.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/global.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/text.dart';

import '../../../../../constants/size_config.dart';
import '../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../fierbase_exceptions.dart';
import 'reset_password.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              Text("Forgot Password", style: headingStyle),
              Text(
                "Please enter your email to get code to return to your account",
                textAlign: TextAlign.center,
                style: bodyTextStyle,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  String email = '';
  String data = '';
  String errorImg = "assets/icons/white.svg";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  errorImg = 'assets/icons/white.svg';
                  data = '';
                });
              }
              // emailController.text = value;
            },
            validator: (Email) {
              if (Email == null || Email.isEmpty) {
                setState(() {
                  errorImg = "assets/icons/Error.svg";
                  data = 'Please enter your email';
                });
                return "";
              } else if (!EmailValidator.validate(Email, true)) {
                setState(() {
                  errorImg = "assets/icons/Error.svg";
                  data = "Invalid Email";
                });
                return "";
              } else if (Email.isNotEmpty) {
                setState(() {
                  errorImg = "assets/icons/white.svg";
                  data = '';
                });
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: tPrimaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              labelText: 'Enter your email',
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
          DefaultButton(
              text: "Reset Password",
              press: () async {
                print(emailController.text);
                if (_formKey.currentState!.validate()) {
                  var response = await http.post(
                      Uri.parse("http://$ip/requestResetPassword"),
                      headers: <String, String>{
                        'Context-Type': 'application/json;charset=UTF-8'
                      },
                      body: {
                        'email': emailController.text,
                      });
                  print(response.body);
                  print(response.statusCode);
                  if (response.statusCode == 201) {
                    print('reset password');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ResetPassScreen(email: emailController.text)));
                  }
                  if (response.statusCode == 404) {
                    print('erorr');

                    return;
                  } else {
                    print("object");
                  }
                }
              }),
              
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          // NoAccountText(),
        ],
      ),
    );
  }
}
