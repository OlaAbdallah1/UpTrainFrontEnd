import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uptrain/src/constants/colors.dart';

import '../../../../../../constants/connections.dart';
import '../../../../../../constants/size_config.dart';
import 'package:http/http.dart' as http;

import '../../../../../../utils/theme/widget_themes/button_theme.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({super.key});

  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final _formKey = GlobalKey<FormState>();

  void save() async {
    try {
      var res = await http.post(Uri.parse("http://$ip:3000/apply"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8'
          },
          body: <String, String>{
            'cv': "kfjk",
            'details': "fkvd"
          });
      if (res.statusCode == 400) {
        setState(() {
          cvError = "Choose valid file ";
        });
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  String cvError = '';

  attachFile(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (result != null) {
      //  File file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
           Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Resume",style: TextStyle(fontSize: 18,color: tPrimaryColor,fontFamily: 'Ubuntu'),),
              SizedBox(height: getProportionateScreenHeight(8),),
          Row(
            children: [

              SizedBox(
                width: getProportionateScreenWidth(200),
                height: getProportionateScreenHeight(45),
                child: buildAttachCVFormField(),
              ),
              SizedBox(
                width: getProportionateScreenWidth(12),
              ),
              OutlinedButton(
                onPressed: () {
                  attachFile(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    width: 1.5,
                    color: tPrimaryColor,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Attach Resume',
                  style: TextStyle(color: tPrimaryColor,),
                ),
              ),
            ],
          ),
            ],),
          // FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("More Details..",style: TextStyle(fontSize: 18,color: tPrimaryColor,fontFamily: 'Ubuntu'),),
              SizedBox(height: getProportionateScreenHeight(8),),
              Row(children: [
                SizedBox(
                  width: getProportionateScreenWidth(320),
                  child: const TextField(
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: 5,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.details_outlined,
                        color: tPrimaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),

          SizedBox(height: getProportionateScreenHeight(20)),

          DefaultButton(
            text: "Apply".toUpperCase(),
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
              } else {
                print("kjhvg");
              }
              // KeyboardUtil.hideKeyboard(context);
              // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAttachCVFormField() {
    return TextFormField(
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {});
        }
        // user.firstName = value;
      },
      validator: (Name) {
        if (Name == null || Name.isEmpty) {
          setState(() {});
          return "";
        } else if (Name.isNotEmpty) {
          setState(() {});
        }
        return null;
      },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.upload_file,
          color: tPrimaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        labelText: 'Attach Resume',
        labelStyle: TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}
