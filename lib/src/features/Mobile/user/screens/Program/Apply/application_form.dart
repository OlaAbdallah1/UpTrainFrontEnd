import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/skills.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/user/models/application.dart';

import '../../../../../../constants/connections.dart';
import '../../../../../../constants/size_config.dart';
import 'package:http/http.dart' as http;

import '../../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../../../authentication/models/user_skills.dart';

class ApplicationForm extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;

  final int programId;

  const ApplicationForm(
      {super.key,
      required this.programId,
      required this.user,
      required this.student,
      required this.skillsO});
  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> combined = {};

  List skillsList = [];
  List filteredSkills = [];
  Set selectedSkills = {};
  Set selectedSkillsId = {};

  UserSkills userSkills = UserSkills(
      user: User(
          id: 0,
          email: '',
          firstName: '',
          lastName: '',
          phone: '',
          location: '',
          location_id: 0,
          field: '',
          photo: '',
          field_id: 0),
      skills: []);

  late User _user = User(
      id: 0,
      email: '',
      firstName: '',
      lastName: '',
      phone: '',
      field: '',
      photo: '',
      location: '',
      field_id: 0,
      location_id: 0);

  void combineData() {
    combined.addAll(widget.user);
    combined.addAll(widget.student);
    print(combined);

    _user = User.fromJson(combined);
  }

  void fetchData() {
    userSkills = UserSkills(user: _user, skills: widget.skillsO);
    for (Skill skill in userSkills.skills) {
      selectedSkills.add(skill.name);
      // selectedSkillsId.add(skill.id);
    }
  }

  late Application application;
  @override
  void initState() {
    skills = getSkills();
    combineData();
    fetchData();
    application = Application(cv: File(''));

    super.initState();
  }

  List<Skill> skillsData = [];
  late Future<List<Skill>> skills = getSkills();
  Future<List<Skill>> getSkills() async {
    String url = "http://$ip/api/getSkills";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      for (Map skill in responseData) {
        skillsData.add(Skill.fromJson(skill));
      }
      return skillsData;
    } else {
      return skillsData;
    }
  }

  void save() async {
    try {
      var res = await http
          .post(Uri.parse("http://$ip/apply"), headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8'
      }, body: {
        'cv': application.cv,
        // 'user_id': _user.id,
        // 'program_id': widget.programId
      });

      if (res.statusCode == 201) {
        setState(() {
          cvError = "Applied successfully";
        });
        return;
      }
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

  // Future<void> _submitForm() async {
  //   if (cvFile == null) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Error'),
  //           content: const Text('Please attach your CV file.'),
  //           actions: <Widget>[
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //     return;
  //   }

  //   // Create multipart request for the API endpoint
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('http://$ip/apply'),
  //   );

  //   // Attach the CV file to the request
  //   request.files.add(
  //     await http.MultipartFile.fromPath('cv', cvFile!.path),
  //   );
  //   request.fields['user_id'] = widget.userId as String;
  //   request.fields['program_id'] = widget.programId as String;

  //   // Send the request and get the response
  //   var response = await request.send();

  //   if (response.statusCode == 201) {
  //     // Success! Handle the response here.
  //     // ignore: use_build_context_synchronously
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Success'),
  //           content: const Text('Application submitted successfully.'),
  //           actions: <Widget>[
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } else {
  //     // Error occurred. Handle the error here.
  //     // ignore: use_build_context_synchronously
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           // ignore: prefer_const_constructors
  //           title: Text('Error'),
  //           content: const Text('An error occurred. Please try again.'),
  //           actions: <Widget>[
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  String cvError = '';
 void removeSkill(Skill skill) {
    print(skill);
    print('removed');
    setState(() {
      userSkills.skills.remove(skill);
      selectedSkills.remove(skill.name);
      selectedSkillsId.remove(skill.id);
    });
  }
  // File? cvFile;

  // Future<void> _selectCVFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc', 'docx'],
  //   );

  //   if (result != null) {
  //     setState(() {
  //       cvFile = File(result.files.single.path!);
  //       application.cv = cvFile!;
  //     });
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: _user.email);
    TextEditingController firstNameController =
        TextEditingController(text: _user.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: _user.lastName);
    TextEditingController phoneController =
        TextEditingController(text: _user.phone);
    TextEditingController locationController =
        TextEditingController(text: _user.location);
    print(_user.id);
    print(widget.programId);
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
                      'Location',
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
                        controller: locationController,
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
                    SizedBox(
                      width: getProportionateScreenWidth(200),
                      child: Wrap(
                        spacing: 4,
                        children: userSkills.skills
                            .map((skill) => Chip(
                                label: Text(skill.name),
                                backgroundColor: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                deleteIconColor: tPrimaryColor,
                                onDeleted: () => removeSkill(skill),
                                ))
                            .toList(),
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
                              // _selectCVFile();
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
        labelText: _user.firstName,
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
        labelText: _user.lastName,
        labelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  TextFormField buildAttachCVFormField() {
    return TextFormField(
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            // value = cvFile!.path.toString();
          });
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.upload_file,
          color: tPrimaryColor,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        // labelText: cvFile!.path.toString(),
        labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}
