import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';

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

  String email = "";
  String password = "";
  String data = '';
  String errorPassImg = "assets/icons/white.svg";
  String errorPhoneImg = "assets/icons/white.svg";
  String errorImg = "assets/icons/white.svg";
  String errorNameImg = "assets/icons/white.svg";
  String pass = '';
  String firstName = '';
  String lastName = '';
  String phone = '';

  User user = User(
    // id: 0,
    email: '',
    field: '',
    firstName: '',
    lastName: '',
    phone: '',
    photo: '',
    field_id: 0,
    location: '',
    location_id: 0
  );

  TextEditingController emailController =
      TextEditingController(text: "user.email");
  TextEditingController firstNameController =
      TextEditingController(text: "user.firstName");
  TextEditingController lastNameController =
      TextEditingController(text: "user.lastName");
  TextEditingController phoneController =
      TextEditingController(text: "user.phone");

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
                  Row(children: [
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.normal,
                        color: tPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: firstNameController,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: tPrimaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: lastNameController,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: tPrimaryColor,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Row(children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.normal,
                        color: tPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: tPrimaryColor,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Row(children: [
                    const Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.normal,
                        color: tPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: tPrimaryColor,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Row(children: [
                    const Text(
                      'Skills',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.normal,
                        color: tPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: tPrimaryColor,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Resume",
                        style: TextStyle(
                            fontSize: 18,
                            color: tPrimaryColor,
                            fontFamily: 'Ubuntu'),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(8),
                      ),
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
                              style: TextStyle(
                                color: tPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // FormError(errors: errors),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "More Details..",
                        style: TextStyle(
                            fontSize: 18,
                            color: tPrimaryColor,
                            fontFamily: 'Ubuntu'),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(8),
                      ),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
            ))));
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorNameImg = 'assets/icons/white.svg';
            firstName = '';
          });
        }
        // user.firstName = value;
      },
      // onSaved: (savedValue) {
      //   user.firstName = savedValue!;
      // },
      validator: (Name) {
        if (Name == null || Name.isEmpty) {
          setState(() {
            errorNameImg = "assets/icons/Error.svg";
            firstName = 'Fill this field';
          });
          return "";
        } else if (Name.isNotEmpty) {
          setState(() {
            errorNameImg = "assets/icons/white.svg";
            firstName = '';
          });
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        labelText: user.firstName,
        labelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorNameImg = 'assets/icons/white.svg';
            lastName = '';
          });
        }
        // user.lastName = value;
      },
      //  onSaved : (savedValue) {
      //     user.lastName = savedValue!;
      //   },
      validator: (Name) {
        if (Name == null || Name.isEmpty) {
          setState(() {
            errorNameImg = "assets/icons/Error.svg";
            lastName = 'Fill this field';
          });
          return "";
        } else if (Name.isNotEmpty) {
          setState(() {
            errorNameImg = "assets/icons/white.svg";
            lastName = '';
          });
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        labelText: user.lastName,
        labelStyle: const TextStyle(color: Colors.black),
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
