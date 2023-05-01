import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:purple/user.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
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
                "Please enter your email and we will send \nyou a link to return to your account",
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
  static final auth = FirebaseAuth.instance;
  static late AuthStatus _status;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status;
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
              // user.email = value;
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
                // if (_formKey.currentState!.validate()) {
                //   // resetPassword();
                //   final _status =
                //       await resetPassword(email: emailController.text.trim());
                //   if (_status == AuthStatus.successful) {
                //     await FirebaseAuth.instance
                //         .sendPasswordResetEmail(email: "user@example.com");
                //   } else {
                //     //your logic or show snackBar with error message
                //     print('error');
                //   }
                // }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ResetPassScreen()));
              }),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          // NoAccountText(),
        ],
      ),
    );
  }
  // Future resetPassword() async {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => Center(child: CircularProgressIndicator(),)
  //   );
  //   try {
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
  //     Get.snackbar('','Password Reset Email Sent');
  //     Navigator.of(context).popUntil((route) => route.isFirst);
  //   } on FirebaseAuthException catch (e){
  //     print(e);
  //     Navigator.of(context).pop();
  //   }
  // }
}
