import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uptrain/global.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Admin/models/Employee.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/connections.dart';
import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../../../../Mobile/authentication/models/field.dart';

class AddEmployeeForm extends StatefulWidget {
  const AddEmployeeForm({super.key});

  @override
  State<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  final _formKey = GlobalKey<FormState>();

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
            title: const Text('Please choose employee photo'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 8,
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
                      children: const [
                        Icon(Icons.image),
                        Text(
                          ' From Gallery',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                    ),
                    //if Company click this button. Company can upload image from camera
                    onPressed: () {
                      pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.camera),
                        const Text(
                          ' From Camera',
                          style: TextStyle(
                            fontSize: 22,
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
          CloudinaryFile.fromFile(image!.path, folder: admin.first_name),
        );
        String basename = path.basename(image!.path);

        setState(() {
          imageUrl = resImage.secureUrl;
          admin.photo = imageUrl;
          print(imageUrl);
          print(admin.photo);
        });
      } else {
        setState(() {
          admin.photo = path.basename("assets/images/profile.png");
          print(admin.photo);

          // const Image(image: AssetImage("assets/images/profile.png"))
          //     as String;
        });
        print("Picture $admin.photo");
      }
      var response = await http.post(Uri.parse("http://$ip/api/addEmployee"),
          headers: <String, String>{
            'Context-Type': 'application/json;charset=UTF-8'
          },
          body: {
            'first_name': admin.first_name,
            'last_name': admin.last_name,
            'email': admin.email,
            'password': admin.password,
            'phone': admin.phone,
            'photo': admin.photo,
          });
      print(response.statusCode);
      // print(response.headers);

      print("final error : jaym " + response.body);

      print(json.encode(admin.toJson()));
      print(response.statusCode);

      // ignore: use_build_context_synchronously
    } catch (error) {
      print("error : ${error}");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    fields= getFields();

    super.initState();
  }

  Employee admin = Employee(
      email: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '');

  String name = '';
  String errorImg = '';
  String namedata = '';
  String emaildata = '';
  String phonedata = '';
  bool _isObscure = false;
  String passdata = '';
  String fieldChoose = '';
  int fieldChooseint = 0;

  List fieldsList = [];

  List<Field> fieldsData = [];
  late Future<List<Field>> fields;
  Future<List<Field>> getFields() async {
    String url = "http://$ip/api/getFields";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    // json.decode(response.body);

    if (response.statusCode == 200) {
      for (Map field in responseData) {
        fieldsData.add(Field.fromJson(field));
      }
      print(fieldsData);
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              Text(
                "New Employee",
                style: TextStyle(
                    fontFamily: 'Ubintu',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: tPrimaryColor),
              ),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
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
                          child:
                              SvgPicture.asset("assets/icons/Camera Icon.svg"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(namedata),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.12,
                            child: buildFirstNameFormField(),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(5),
                      ),
                      Column(
                        children: [
                          Text(namedata),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.12,
                            child: buildLastNameFormField(),
                          ),
                        ],
                      )
                    ],
                  ),
                   Row(
                    children: [
                      Text(emaildata),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.25,
                    child: buildEmailFormField(),
                  ),
                  Row(
                    children: [
                      Text(phonedata),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.25,
                    child: buildPhoneFormField(),
                  ),
                  Row(
                    children: [
                      Text(passdata),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.25,
                    child: buildPasswordFormField(),
                  ),
                  // SizedBox(
                  //   width: SizeConfig.screenWidth * 0.25,
                  //   child: FutureBuilder(
                  //       future: fields,
                  //       builder: (context, snapshot) {
                  //         if (snapshot.hasData) {
                  //           fieldsList = snapshot.data!;
                  //           return FormBuilder(
                  //             child: FormBuilderDropdown<dynamic>(
                  //               decoration: const InputDecoration(
                  //                 labelText: 'Select Field',
                  //                 labelStyle: TextStyle(color: Colors.black),
                  //                 prefixIcon: Icon(
                  //                   Icons.work_outline,
                  //                   color: tPrimaryColor,
                  //                 ),
                  //               ),
                  //               onChanged: (dynamic newField) {
                  //                 setState(() {
                  //                   fieldChoose = newField.name;
                  //                   admin.field = fieldChoose;
                  //                   // print("field selected");
                  //                   print(admin.field);
                  //                 });
                  //               },
                  //               valueTransformer: (dynamic value) => value.id,
                  //               items: fieldsList
                  //                   .map((field) => DropdownMenuItem(
                  //                       value: field, child: Text(field.name)))
                  //                   .toList(),
                  //               name: '',
                  //             ),
                  //           );
                  //         }
                  //         print("No fields");
                  //         return const CircleAvatar();
                  //       }),
                  // ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(30),
                  ),
                  DefaultButton(
                    text: "Add Employee",
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        save();
                        print(
                            "${admin.first_name} ${admin.last_name} added successfully");
                      } else {
                        print("not oky");
                      }
                    },
                  ),
                ],
              ),
            ]));
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (Email) {
        if (Email == null || Email.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            emaildata = 'Please enter your email';
          });
          return "";
        } else if (!EmailValidator.validate(Email, true)) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            emaildata = "Invalid Email";
          });
          return "";
        } else if (Email.isNotEmpty) {
          setState(() {
            errorImg = "assets/icons/white.svg";
            emaildata = '';
          });
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            emaildata = '';
          });
        }
        admin.email = value;
      },
      // onSaved: (savedValue) {
      //   admin.email = savedValue!;
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _isObscure,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            passdata = '';
          });
        }
        admin.password = value;
      },
      // onSaved: (savedValue) {
      //   // admin.password = savedValue!;
      // },
      validator: (password) {
        if (password == null || password.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            passdata = 'Please enter your password';
          });
          return "";
        } else if (password.isNotEmpty) {
          if (password.length < 4) {
            setState(() {
              errorImg = "assets/icons/Error.svg";
              passdata = "Short password";
            });
            return "";
          } else {
            setState(() {
              errorImg = 'assets/icons/white.svg';
              passdata = '';
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

  TextFormField buildPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            phonedata = "";
          });
        }
        admin.phone = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            phonedata = 'Please enter your phone';
          });
          return "";
        } else {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            phonedata = phonedata;
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
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (Name) {
        if (Name == null || Name.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            namedata = 'Please enter your full name';
          });
          return "";
        } else if (Name.isNotEmpty) {
          setState(() {
            errorImg = "assets/icons/white.svg";
            namedata = '';
          });
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            namedata = '';
          });
        }
        admin.first_name = value;
      },
      // onSaved: (savedValue) {
      //   admin.email = savedValue!;
      // },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        labelText: 'First Name',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (Name) {
        if (Name == null || Name.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            namedata = 'Please enter your full name';
          });
          return "";
        } else if (Name.isNotEmpty) {
          setState(() {
            errorImg = "assets/icons/white.svg";
            namedata = '';
          });
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            namedata = '';
          });
        }
        admin.last_name = value;
      },
      // onSaved: (savedValue) {
      //   admin.email = savedValue!;
      // },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        labelText: 'Last Name',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
}
