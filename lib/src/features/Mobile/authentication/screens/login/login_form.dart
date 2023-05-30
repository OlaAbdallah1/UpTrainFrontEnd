import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/dashboard_screen.dart';
import 'package:uptrain/src/features/Website/Company/company_dashboard.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import '../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../../../../../global.dart' as global;
import 'package:http/http.dart' as http;

import '../../../../Website/Admin/screens/Admin_Dashboard/Employees/employees_screen.dart';
import '../../../../Website/Employee/employee_dashboard.dart';
import '../../../user/screens/Home/home_page_screen.dart';
import '../../models/skills.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../../models/user.dart';
import '../student_signup/sign_up_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  void save() async {
    try {
      var res = await http.post(Uri.parse("http://$ip/api/login"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: {
            'email': user.email,
            'password': user.password
          });
      // print(user.id);
      print(user.email);
      print(user.password);
      print(res.statusCode);
      var decoded = json.decode(res.body);

      if (res.statusCode == 201) {
        // save user data to local storage
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', user.email);
        global.token = decoded['token'];

        //Students
        Map<String, dynamic> decodedUser = decoded['user'];
        Map<String, dynamic> decodedStudent = decoded['student'];

        List<Skill> skills = [];

        for (var skillJson in decoded['skills']) {
          Skill skill = Skill.fromJson(skillJson);
          skills.add(skill);
        }

        if (decodedUser.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: decodedUser,
              student: decodedStudent,
              skills: skills,
            ),
          ));
        }

        //   //Admin & Employees
        //   Map<String, dynamic> decodedEmployee = decoded['employee'];
        // // Admin
        //   if (decodedEmployee['eRole'] == 1) {
        //     Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => DashboardScreen(),
        //     ));
        //   //Employees
        //   } else if (decodedEmployee['eRole'] == 0) {
        //     Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => EmployeeDashboardScreen(employee: decodedEmployee, user: decodedUser,),
        //     ));
        //   }
        // Map<String, dynamic> decodedTrainer = decoded['trainer'];

        // if (decodedTrainer.isNotEmpty) {

        // }

        // Map<String, dynamic> decodedCompany = decoded['company'];
        // if (decodedCompany.isNotEmpty) {
        //     Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => CompanyDashboardScreen(company: decodedCompany),
        //     ));
        // }
      }

      if (res.statusCode == 400) {
        setState(() {
          errorPassImg = "assets/icons/Error.svg";
          passwordError = "Email or Password is not correct";
        });
        return;
      }
      print("final error : jaym " + res.body);
      // global.token = decoded['token'];
      if (kDebugMode) {
        print("token");
        print(global.token);
      }
    } catch (e) {
      print(e);
      // show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login failed')));
    }
  }

  String email = "";
  String password = "";

  User user = User(
      id: 0,
      firstName: '',
      lastName: '',
      email: '',
      field: '',
      phone: '',
      field_id: 0,
      location: '',
      location_id: 0,
      photo: '');
  bool _isObscure = true;
  String emailError = '';
  String errorPassImg = "assets/icons/white.svg";
  String errorImg = "assets/icons/white.svg";
  String passwordError = '';
  String str = '';

  bool? remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // physics: const AlwaysScrollableScrollPhysics(),
        reverse: true,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                      Text(
                        emailError,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(7)),

                  buildEmailFormField(),
                  SizedBox(height: getProportionateScreenHeight(25)),
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
                      Text(
                        passwordError,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(7)),
                  buildPasswordFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen())),
                        child: const Text(
                          "Forgot Password",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                  // FormError(errors: errors),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  DefaultButton(
                    text: "Login".toUpperCase(),
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        save();

                        // if all are valid then go to success screen
                      } else {
                        print("kjhvg");
                      }
                      // KeyboardUtil.hideKeyboard(context);
                      // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ))));
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _isObscure,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorPassImg = 'assets/icons/Error.svg';
            passwordError = '';
          });
        }
        user.password = value;
      },
      // onSaved: (newValue) => user.password = newValue!,
      validator: (Password) {
        if (Password == null || Password.isEmpty) {
          setState(() {
            errorPassImg = "assets/icons/Error.svg";
            passwordError = 'Please enter your password';
          });
          return "";
        } else if (Password.isNotEmpty) {
          setState(() {
            errorPassImg = 'assets/icons/white.svg';
            passwordError = '';
          });
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(26),
            horizontal: getProportionateScreenWidth(12)),
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
        labelText: 'Enter your password',
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            emailError = '';
          });
        }
        user.email = value;
      },
      // onSaved: (newValue) => user.email = newValue!,
      validator: (Email) {
        if (Email == null || Email.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            emailError = 'Please enter your email';
          });
          return "";
        } else if (!EmailValidator.validate(Email, true)) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            emailError = "Invalid Email";
          });
          return "";
        } else if (Email.isNotEmpty) {
          setState(() {
            errorImg = "assets/icons/white.svg";
            emailError = '';
          });
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(26),
            horizontal: getProportionateScreenWidth(12)),
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
    );
  }
}
