import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:html/parser.dart' as html_parser;

import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import 'package:path/path.dart' as path;
import '../../../../../utils/theme/widget_themes/button_theme.dart';

import '../../models/field.dart';
import '../../models/skills.dart';
import '../../models/user.dart';
import 'verify_email.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fields = getFields();
    skills = getSkills();
    // skillsController.text = '';

    super.initState();
  }

  @override
  void dispose() {
    skillsSearchController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  File? image;
  String imageUrl = '';

  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final imgTemp = File(img.path);

      setState(() {
        image = imgTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose your profile picture'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
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
                      backgroundColor: tPrimaryColor,
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

  void save() async {
    try {
      if (image != null) {
        final cloudinary = CloudinaryPublic('dsmn9brrg', 'ul29zf8l');

        CloudinaryResponse resImage = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image!.path, folder: user.firstName),
        );
        String basename = path.basename(image!.path);

        setState(() {
          imageUrl = resImage.secureUrl;
          user.picture = imageUrl;
          print(imageUrl);
          print(user.picture);
        });
      } else {
        setState(() {
          user.picture = path.basename("assets/images/profile.png");
          print(user.picture);

          // const Image(image: AssetImage("assets/images/profile.png"))
          //     as String;
        });
        print("Picture $user.picture");
      }
      var response = await http.post(Uri.parse("http://$ip:8000/api/register"),
          headers: <String, String>{
            'Context-Type': 'application/json;charset=UTF-8'
          },
          body:
              // json.encode(user.toJson()),

              {
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'password': user.password,
            'phone': user.phone,
            'picture': user.picture,
            'field': fieldChooseint.toString(),
            'skills': selectedSkillsId.join(','),

            // 'collage': collage,
          }
          // email: user.email,
          //                 password: user.password,
          //                 firstName: firstName,
          //                 lastName: user.lastName,
          //                 phone: user.phone,
          //                 picture: user.picture,
          //                 field: fieldChooseint,
          //                 skills: selectedSkillsId.join(',')
          );
      print(response.statusCode);
      // print(response.headers);
      if (response.statusCode == 302) {
        html_parser.parse(response.body);
        print("body : ");
        print(html_parser.parse(response.body));
      } else {
        print("final error : jaym " + response.body);
      }
      print(json.encode(user.toJson()));
      print(response.statusCode);

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Welcome'),
          content: const Text("Your have to verify your email"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: tPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyEmailScreen(user: user))),
              child: Text('Verify',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(14),
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      );
    } catch (error) {
      print("error : ${error}");
    } catch (e) {
      print(e);
    }
  }

  User user = User(
      id: 0,
      firstName: '',
      lastName: '',
      email: '',
      password: '',
      phone: '',
      field: 0,
      skills: '',
      picture: '');
  String Name = "";
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
  bool _isObscure = true;

  String fieldChoose = '';
  int fieldChooseint = 0;
  List skillsList = [];
  List filteredSkills = [];
  Set selectedSkills = {};
  Set selectedSkillsId = {};

  TextEditingController skillsSearchController = TextEditingController();
  TextEditingController skillsController = TextEditingController();

  List<Skill> skillsData = [];
  late Future<List<Skill>> skills;
  Future<List<Skill>> getSkills() async {
    String url = "http://$ip:8000/api/getSkills";
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
    String url = "http://$ip:8000/api/getFields";
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
                        backgroundImage: FileImage(image!), radius: 200.0)
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
                      onPressed: () {
                        myAlert();
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(color: Colors.white),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                    ),
                  ),
                )
              ],
            ),
          ),
          // SizedBox(
          //   height: getProportionateScreenHeight(10),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        errorImg,
                        height: getProportionateScreenWidth(14),
                        width: getProportionateScreenWidth(14),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(5),
                      ),
                      Text(firstName),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.40,
                    child: buildFirstNameFormField(),
                  ),
                ],
              ),
              Column(
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
                      Text(lastName),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.40,
                    child: buildLastNameFormField(),
                  ),
                ],
              )
            ],
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
          buildEmailFormField(),

          Row(
            children: [
              SvgPicture.asset(
                errorPhoneImg,
                height: getProportionateScreenWidth(14),
                width: getProportionateScreenWidth(14),
              ),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
            ],
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  errorPhoneImg = 'assets/icons/white.svg';
                  phone = value;
                });
              }
              user.phone = value;
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
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: tPrimaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: 'Phone',
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          // SizedBox(
          //   height: getProportionateScreenHeight(10),
          // ),
          Row(
            children: [
              SvgPicture.asset(
                errorPassImg,
                height: getProportionateScreenWidth(14),
                width: getProportionateScreenWidth(14),
              ),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              Text(pass),
            ],
          ),
          buildPasswordFormField(),

          FutureBuilder(
              future: getFields(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  fieldsList = snapshot.data!;
                  // print("fieldsList");
                  // print(fieldsData);
                  return FormBuilder(
                    child: FormBuilderDropdown<dynamic>(
                      decoration: const InputDecoration(
                        labelText: 'Select Your Field',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.work_outline,
                          color: tPrimaryColor,
                        ),
                      ),
                      onChanged: (dynamic newFieldId) {
                        setState(() {
                          fieldChooseint = newFieldId.id;
                          user.field = fieldChooseint;
                          // print("field selected");
                          print(user.field);
                        });
                      },
                      valueTransformer: (dynamic value) => value.id,
                      items: fieldsList
                          .map((field) => DropdownMenuItem(
                              value: field, child: Text(field.name)))
                          .toList(),
                      name: '',
                    ),
                  );
                }
                print("No fields");
                return const CircleAvatar();
              }),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),

          FutureBuilder(
              future: skills,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  skillsList = snapshot.data!;
                  // print("skillslist");
                  // print(skillsData);
                  return Column(
                    children: [
                      TextField(
                        controller: skillsSearchController,
                        decoration: const InputDecoration(
                          hintText: 'Search for skills',
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
                      if (skillsSearchController
                          .text.isNotEmpty) // Only show when search text exists
                        const SizedBox(height: 16.0),
                      if (skillsSearchController
                          .text.isNotEmpty) // Only show when search text exists
                        SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredSkills.length,
                            itemBuilder: (BuildContext context, int index) {
                              final skill = filteredSkills[index].name;
                              final skillId = filteredSkills[index].id;
                              final bool isSelected =
                                  selectedSkills.contains(skill);
                              return CheckboxListTile(
                                title: Text(skill),
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedSkills.remove(skill);
                                    } else {
                                      selectedSkills.add(skill);
                                      selectedSkillsId.add(skillId);
                                      user.skills = selectedSkillsId.join(',');
                                      print(selectedSkillsId.join(','));
                                      print(user.skills);
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
            children: [
              TextFormField(
                controller:
                    TextEditingController(text: selectedSkills.join(', ')),
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.settings,
                      color: tPrimaryColor,
                    ),
                    hintText: 'Your Skills',
                    hintStyle: TextStyle(color: Colors.black)),
                enabled: false,
                // onChanged: (dynamic value) => user.skills = value.split(', ').toSet(),
                // onSaved: (dynamic newValue) => user.skills = newValue,
              ),
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          DefaultButton(
            text: "Sign Up".toUpperCase(),
            press: () {
              if (_formKey.currentState!.validate()) {
                save();
                print("Registered successfully");
              } else {
                print("not oky");
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _isObscure,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorPassImg = 'assets/icons/white.svg';
            pass = '';
          });
        }
        user.password = value;
      },
      // onSaved: (savedValue) {
      //   // user.password = savedValue!;
      // },
      validator: (password) {
        if (password == null || password.isEmpty) {
          setState(() {
            errorPassImg = "assets/icons/Error.svg";
            pass = 'Please enter your password';
          });
          return "";
        } else if (password.isNotEmpty) {
          if (password.length < 4) {
            setState(() {
              errorPassImg = "assets/icons/Error.svg";
              pass = "Short password";
            });
            return "";
          } else {
            setState(() {
              errorPassImg = 'assets/icons/white.svg';
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
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
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
        user.email = value;
      },
      // onSaved: (savedValue) {
      //   user.email = savedValue!;
      // },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.alternate_email,
          color: tPrimaryColor,
        ),
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
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
        user.firstName = value;
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
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        labelText: 'First Name',
        labelStyle: TextStyle(color: Colors.black),
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
        user.lastName = value;
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
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        labelText: 'Last Name',
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
