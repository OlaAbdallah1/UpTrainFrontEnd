import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user_skills.dart';
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
import '../../../../authentication/models/skills.dart';
import '../../../../authentication/models/user.dart';

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
  bool isButtonEnabled = false;
  late Map<String, dynamic> combined = {};

  UserSkills userSkills = UserSkills(
      user: User(
          email: '',
          firstName: '',
          lastName: '',
          phone: '',
          field: '',
          picture: '',
          field_id: 0),
      skills: []);
  late User _user = User(
    email: '',
    firstName: '',
    lastName: '',
    phone: '',
    field: '',
    picture: '',
    field_id: 0,
  );
  void combineData() {
    combined.addAll(widget.user);
    combined.addAll(widget.student);
    print(combined);
    _user = User.fromMap(combined);
    // print(_user);
  }

  void fetchData() {
    userSkills = UserSkills(user: _user, skills: widget.skillsO);
    print(userSkills.skills);
  }

  @override
  void initState() {
    fields = getFields();
    skills = getSkills();
    selectedSkills = userSkills.skills;
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

  bool circular = true;
  String errorPhoneImg = "assets/icons/white.svg";
  String phone = '';
  String namme = '';
  String errorNameImg = "assets/icons/white.svg";

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

      var res = await http
          .patch(Uri.parse("http://$ip:3000/users"), headers: <String, String>{
        'Context-Type': 'application/json;charSet=UTF-8',
        'Authorization': global.token
      }, body: {
        'firstName': _user.firstName,
        'lastName': _user.lastName,
        'email': _user.email,
        'password': _user.password,
        'phone': _user.phone,
        'picture': _user.picture,
        'field_id': fieldChooseint as int,
        'skills': selectedSkillsId.join(','),
        // 'field':
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
              onPressed: () => Navigator.pop(context),
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

  String fieldChoose = '';
  int fieldChooseint = 0;
  List skillsList = [];
  List filteredSkills = [];
  List<Skill> selectedSkills = [];
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

  List fieldsList = [];
  List<Field> fieldsData = [];
  late Future<List<Field>> fields;
  Future<List<Field>> getFields() async {
    String url = "http://$ip/api/getFields";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    // json.decode(response.body);

    if (response.statusCode == 201) {
      for (Map field in responseData) {
        fieldsData.add(Field.fromJson(field));
      }
      return fieldsData;
    } else {
      return fieldsData;
    }
  }

  void removeSkill(Skill skill) {
    print(skill);
    print('removed');
    setState(() {
      userSkills.skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: _user.email);
    TextEditingController phoneController =
        TextEditingController(text: _user.phone);
    TextEditingController fieldController =
        TextEditingController(text: _user.field);
    // TextEditingController editSkillsController =
    //     TextEditingController(text: widget.skills);

    return Form(
      key: _formKey,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 115,
                        width: 115,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            image != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(image!),
                                    radius: 200.0)
                                : const CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/profile.png"),
                                  ),
                            Positioned(
                              right: -16,
                              bottom: 0,
                              child: SizedBox(
                                height: 46,
                                width: 46,
                                child: TextButton(
                                  child: SvgPicture.asset(
                                      "assets/icons/Camera Icon.svg"),
                                  onPressed: () {
                                    myAlert();
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // ProfilePic(),
                      const SizedBox(width: 50.0),
                      Text(
                        "${_user.firstName} ${_user.lastName}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          color: tPrimaryColor,
                        ),
                      ),
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
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        enabled: isEnabled,
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
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        enabled: isEnabled,
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
                  const Divider(color: Colors.black54),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Row(children: [
                    const Text(
                      'Field',
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
                    Expanded(
                      child: TextFormField(
                        controller: fieldController,
                        enabled: isEnabled,
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
                            print("skillslist");
                            print(skillsList.length);
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
                                            userSkills.skills.contains(skill);
                                        return CheckboxListTile(
                                          title: Text(skill.name),
                                          value: isSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              if (isSelected) {
                                                userSkills.skills
                                                    .remove(skill.name);
                                              } else {
                                                userSkills.skills.add(skill);
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
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: 300,
                        height: getProportionateScreenHeight(50),
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
                      Button2(
                        text: "Change password",
                        press: () {},
                        child: const Text(''),
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
