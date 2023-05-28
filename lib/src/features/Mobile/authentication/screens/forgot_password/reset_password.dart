import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../../../../../constants/colors.dart';
import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import '../../../../../constants/text.dart';
import '../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../fierbase_exceptions.dart';
import 'change_password/change_password_screen.dart';

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({super.key});

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
              Text("Reset Password", style: headingStyle),
              Text(
                "Please enter your the code you recieve on email from Uptrain",
                textAlign: TextAlign.center,
                style: bodyTextStyle,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ResetPassForm(),
            ],
          ),
        ),
      ),
    ));
  }
}

class ResetPassForm extends StatefulWidget {
  @override
  _ResetPassFormState createState() => _ResetPassFormState();
}

class _ResetPassFormState extends State<ResetPassForm> {
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
  String codeError = '';
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

          DefaultButton(
              text: "Confirm",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  var res = await http.post(
                    Uri.parse("http://$ip/verifyResetPassword"),
                    headers: <String, String>{
                      'Context-Type': 'application/json;charSet=UTF-8'
                    },
                  );
                  if (res.statusCode == 400) {
                    setState(() {
                      codeError = "Your code does not match the right one";
                    });

                    return;
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()));
                  }
                }
              }),
        SizedBox(height: getProportionateScreenHeight(30)),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Resend Code",
              style:
                  TextStyle(fontSize: 18, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
