import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Mobile/user/screens/profile/myAccount/account_details.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/myAccount/my_account.dart';
import 'package:uptrain/src/utils/theme/widget_themes/button_theme.dart';
import '../../../../../../../../global.dart' as global;

class Body extends StatelessWidget {
  String email;
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;
  Body(
      {super.key,
      required this.email,
      required this.user,
      required this.student,
      required this.skillsO});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              Text("Change Password", style: headingStyle),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ChangePasswordForm(
                email: email,
                user: user,
                skillsO: skillsO,
                student: student,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  String email;
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;
  ChangePasswordForm(
      {super.key,
      required this.email,
      required this.user,
      required this.student,
      required this.skillsO});

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildNewPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
              text: "Change Password",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  var response = await http.post(
                      Uri.parse("http://$ip/api/changePassword"),
                      headers: <String, String>{
                        'Context-Type': 'application/json;charset=UTF-8',
                      },
                      body: {
                        'old-password': passwordController.text,
                        'new-password': newPasswordController.text,
                        'email': widget.email
                      });
                  print(response.body);
                  print(response.statusCode);
                  if (response.statusCode == 201) {
                    print('Changed password successfully');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyAccount(
                              skills: widget.skillsO,
                              user: widget.user,
                              student: widget.student,
                            )));
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
        ],
      ),
    );
  }

  bool _isObscure = true;
  String email = '';
  String pass = '';
  String errorImg = "";

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _isObscure,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            pass = '';
          });
        }
        // user.password = value;
      },
      validator: (Password) {
        if (Password == null || Password.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            pass = 'Please enter your password';
          });
          return "";
        } else if (Password.isNotEmpty) {
          if (Password.length < 4) {
            setState(() {
              errorImg = "assets/icons/Error.svg";
              pass = "Short password";
            });
            return "";
          } else {
            setState(() {
              errorImg = 'assets/icons/white.svg';
              pass = '';
            });
          }
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock_open,
          color: tPrimaryColor,
        ),
        suffixIcon: IconButton(
            icon: Icon(
                color: tPrimaryColor,
                _isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }),
        labelText: 'Old Password',
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }

  TextFormField buildNewPasswordFormField() {
    return TextFormField(
      controller: newPasswordController,
      obscureText: _isObscure,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            pass = '';
          });
        }
        // user.password = value;
      },
      validator: (Password) {
        if (Password == null || Password.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            pass = 'New password';
          });
          return "";
        } else if (Password.isNotEmpty) {
          if (Password.length < 4) {
            setState(() {
              errorImg = "assets/icons/Error.svg";
              pass = "Short password";
            });
            return "";
          } else {
            setState(() {
              errorImg = 'assets/icons/white.svg';
              pass = '';
            });
          }
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock_open,
          color: tPrimaryColor,
        ),
        suffixIcon: IconButton(
            icon: Icon(
                color: tPrimaryColor,
                _isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }),
        labelText: 'New Password',
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
}
