import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';

import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../../models/user.dart';

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
              Text("Change Password", style: headingStyle),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ChangePasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
              text: "Change Password",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  // resetPassword();
                  // final _status = await 

                  } else {
                    //your logic or show snackBar with error message
                    print('error');
                  }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
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
  User user = User(id: 0, firstName: '',lastName: '', email: '', phone: '',field_id: 0 , photo: '',field: '',location: '',
  location_id: 0
  );

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _isObscure,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            pass = '';
          });
        }
        user.password = value;
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
        labelText: 'New Password',
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
}
