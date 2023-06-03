import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user_skills.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/myAccount/changePassword/change_password_screen.dart';
import 'package:uptrain/src/utils/theme/widget_themes/button2_theme.dart';
import '../../../../../../constants/connections.dart';
import '../../../../../../constants/size_config.dart';
import 'package:uptrain/global.dart' as global;
import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import '../../../../authentication/models/field.dart';
import '../../../../authentication/models/location.dart';
import '../../../../authentication/models/skills.dart';
import '../../../../authentication/models/user.dart';
import '../profile_pic.dart';

class AccountDetails extends StatefulWidget {
  // AccountDetails({Key? key}) : super(key: key);
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;

  const AccountDetails(
      {super.key,
      required this.user,
      required this.student,
      required this.skillsO});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final _formKey = GlobalKey<FormState>();

  bool isEnabled = false;
  bool isNameEnabled = false;
  bool isButtonEnabled = false;
  late Map<String, dynamic> combined = {};

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
      selectedSkillsId.add(skill.id);
    }
    print(selectedSkills);
    print(userSkills.skills);
  }

  @override
  void initState() {
    skills = getSkills();
    locations = getLocations();
    combineData();
    fetchData();

    super.initState();
  }

  @override
  void dispose() {
    skillsSearchController.dispose();
    skillsController.dispose();
    _formKey.currentState!.dispose();

    super.dispose();
  }

  String Name = "";
  String email = "";
  String password = "";
  String data = '';
  String errorPassImg = "assets/icons/white.svg";
  String errorPhoneImg = "assets/icons/white.svg";
  String errorImg = "assets/icons/white.svg";
  String errorNameImg = "assets/icons/white.svg";
  String errorLocImg = 'assets/icons/white.svg';
  String locationData = '';
  String pass = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  bool circular = true;
  String namme = '';

  File? image;
  String imageUrl = '';

  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final img_temp = File(img.path);

      setState(() {
        this.image = img_temp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: tPrimaryColor,
                    ),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.image),
                        Text(
                          ' From Gallery',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: tPrimaryColor,
                    ),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.camera),
                        Text(
                          ' From Camera',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void edit() async {
    try {
      if (image != null) {
        final cloudinary = CloudinaryPublic('dsmn9brrg', 'ul29zf8l');

        CloudinaryResponse resImage = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image!.path, folder: _user.firstName),
        );

        setState(() {
          imageUrl = resImage.secureUrl;

          // user.picture = imageUrl;
        });
      }

      var res = await http.patch(Uri.parse("http://$ip/api/updateStudent"),
          headers: <String, String>{
            'Context-Type': 'application/json;charSet=UTF-8',
            'Authorization': global.token
          },
          body: {
            // 'id': _user.id,
            'firstName': _user.firstName,
            'lastName': _user.lastName,
            'email': _user.email,
            'phone': _user.phone,
            'photo': _user.photo,
            'location_id': '1',
            'skills': selectedSkillsId.join(','),
          });
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('modified'),
          content:
              const Text("Your information has been successfully modified"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: tPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => {
                isButtonEnabled = false,
                isEnabled = false,
                print(_user.email),
                print(_user.skills),
                Navigator.pop(context)
              },
              child: Text('OK',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(14),
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      );
    } catch (e) {
      print(" edit account");
      print(e);
    }
  }

  String locationChoose = '';
  int locationChooseint = 0;
  List skillsList = [];
  List filteredSkills = [];
  Set selectedSkills = {};
  Set selectedSkillsId = {};

  TextEditingController skillsSearchController = TextEditingController();
  TextEditingController skillsController = TextEditingController();

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

  void removeSkill(Skill skill) {
    print(skill);
    print('removed');
    setState(() {
      userSkills.skills.remove(skill);
      selectedSkills.remove(skill.name);
      selectedSkillsId.remove(skill.id);
    });
  }

  List locationsList = [];

  List<Location> locationsData = [];
  late Future<List<Location>> locations;
  Future<List<Location>> getLocations() async {
    String url = "http://$ip/api/getLocations";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    // json.decode(response.body);

    if (response.statusCode == 201) {
      for (Map location in responseData) {
        locationsData.add(Location.fromJson(location));
      }

      return locationsData;
    } else {
      return locationsData;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController fieldController =
        TextEditingController(text: '${_user.field} Student');
    // TextEditingController editSkillsController =
    //     TextEditingController(text: widget.skills);
    // print(_user.id);
    print('id');
    print(_user.id);
    locationChoose = _user.location;
    return Form(
      key: _formKey,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      ProfilePic(
                        user: _user,
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: buildFirstNameFormField()),
                                SizedBox(width: 5.0),
                                Expanded(child: buildLastNameFormField()),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isNameEnabled = true;
                                        isButtonEnabled = true;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: tPrimaryColor,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Row(children: [
                              Expanded(
                                child: Text(
                                  fieldController.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      // Text(
                      //   "${_user.firstName} ${_user.lastName}",
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontFamily: 'Ubuntu',
                      //     fontWeight: FontWeight.bold,
                      //     color: tPrimaryColor,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(34),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isEnabled = true;
                                isButtonEnabled = true;
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: tPrimaryColor,
                            )),
                        const Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            color: tPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.black54),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Row(children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Expanded(child: buildEmailFormField()),
                  ]),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  const Divider(color: Colors.black54),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Row(children: [
                    const Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Expanded(child: buildPhoneFormField()),
                  ]),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  const Divider(color: Colors.black54),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Row(children: [
                    const Text(
                      'Skills',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
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
                  if (isEnabled)
                    FutureBuilder(
                        future: skills,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            skillsList = snapshot.data!;
                            return Column(
                              children: [
                                TextField(
                                  controller: skillsSearchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Add new skills',
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: tPrimaryColor,
                                    ),
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (value) {
                                    setState(() {
                                      filteredSkills = skillsList
                                          .where((skill) => skill.name
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                          .toList();
                                    });
                                  },
                                ),
                                if (skillsSearchController.text
                                    .isNotEmpty) // Only show when search text exists
                                  const SizedBox(height: 16.0),
                                if (skillsSearchController.text
                                    .isNotEmpty) // Only show when search text exists
                                  SizedBox(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: filteredSkills.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final skill = filteredSkills[index];
                                        final skillId = skill.id;
                                        final bool isSelected =
                                            selectedSkills.contains(skill.name);
                                        return CheckboxListTile(
                                          title: Text(skill.name),
                                          value: isSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              if (isSelected) {
                                                // selectedSkills.remove(skill.name);
                                                selectedSkillsId
                                                    .remove(skill.id);
                                              } else {
                                                userSkills.skills.add(skill);
                                                // selectedSkills.add(skill.name);
                                                selectedSkillsId.add(skillId);
                                                _user.skills =
                                                    selectedSkillsId.join(',');
                                                print(
                                                    selectedSkillsId.join(','));
                                                print(_user.skills);
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  )
                              ],
                            );
                          }
                          print("No skills");
                          return const CircleAvatar();
                        }),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: 250,
                        height: getProportionateScreenHeight(45),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: const BorderSide(
                                          color: tPrimaryColor))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (isButtonEnabled == false)
                                    return Colors.grey;
                                  else
                                    return tPrimaryColor; // Use the component's default.
                                },
                              )),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              isButtonEnabled ? edit() : null;
                            } else {
                              print("not oky");
                            }
                          },
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Ubuntu'),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.015),
                      SizedBox(
                        width: 250,
                        height: getProportionateScreenHeight(45),
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: tLightColor,
                            side: const BorderSide(
                              width: 1.5,
                              color: tPrimaryColor,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChangeUserPasswordScreen(
                                      email: _user.email,
                                      skillsO: widget.skillsO,
                                      user: widget.user,
                                      student: widget.student,
                                    )));
                          },
                          child: const Text(
                            "Change Password",
                            style: TextStyle(
                                fontSize: 18,
                                color: tPrimaryColor,
                                fontFamily: 'Ubuntu'),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      initialValue: _user.phone,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorPhoneImg = 'assets/icons/white.svg';
            phone = '';
          });
        }
        _user.phone = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          setState(() {
            errorPhoneImg = "assets/icons/Error.svg";
            phone = 'Please enter your phone';
          });
          return "";
        } else {
          setState(() {
            errorPhoneImg = 'assets/icons/white.svg';
            phone = phone;
          });
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: tPrimaryColor,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      initialValue: _user.email,
      keyboardType: TextInputType.emailAddress,
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
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            data = '';
          });
        }
        _user.email = value;
      },
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: tPrimaryColor,
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      initialValue: _user.firstName,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorNameImg = 'assets/icons/white.svg';
            firstName = '';
          });
        }
        _user.firstName = value;
      },
      // onSaved: (savedValue) {
      //   _user.firstName = savedValue!;
      // },
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: tPrimaryColor,
      ),
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
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      initialValue: _user.lastName,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorNameImg = 'assets/icons/white.svg';
            lastName = '';
          });
        }
        _user.lastName = value;
      },
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: tPrimaryColor,
      ),
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
    );
  }
}

// Image logoWidget(String imageName){
//   return Image.asset(
//     imageName,
//     fit: BoxFit.fitWidth,
//     width: 200,
//     height: 200,
//     //  color: Colors.black,
//
//   );
// }
// }
