import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:uptrain/src/features/Mobile/user/models/company.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import '../../../../../utils/theme/widget_themes/button_theme.dart';

class AddCompanyForm extends StatefulWidget {
  const AddCompanyForm({super.key});

  @override
  State<AddCompanyForm> createState() => _AddCompanyFormState();
}

class _AddCompanyFormState extends State<AddCompanyForm> {
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
            title: const Text('Please choose company photo'),
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
          CloudinaryFile.fromFile(image!.path, folder: company.name),
        );
        String basename = path.basename(image!.path);

        setState(() {
          imageUrl = resImage.secureUrl;
          company.photo = imageUrl;
          print(imageUrl);
          print(company.photo);
        });
      } else {
        setState(() {
          company.photo = path.basename("assets/images/profile.png");
          print(company.photo);

          // const Image(image: AssetImage("assets/images/profile.png"))
          //     as String;
        });
        print("Picture $company.photo");
      }
      var response = await http.post(Uri.parse("http://$ip/api/addCompany"),
          headers: <String, String>{
            'Context-Type': 'application/json;charset=UTF-8'
          },
          body: {
            'name': company.name,
            'email': company.email,
            'password': company.password,
            // 'phone': company.phone,
            'photo': company.photo,
            'location': company.location,
            'website': company.website,
          });

      // if (response.statusCode == 201) {

      // }
      print(response.statusCode);
      // print(response.headers);

      print("final error : jaym " + response.body);

      print(json.encode(company.toJson()));
      print(response.statusCode);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Welcome'),
          content: const Text("Company Added Successfully"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: tPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => {},
              child: Text('Ok',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(14),
                    color: tPrimaryColor,
                  )),
            ),
          ],
        ),
      );
      print("${company.name} added successfully");

      // ignore: use_build_context_synchronously
    } catch (error) {
      print("error : ${error}");
    } catch (e) {
      print(e);
    }
  }

  Company company = Company(
      email: '',
      // password: '',
      name: '',
      description: '',
      location: '',
      website: '',
      photo: '');

  String name = '';
  String errorImg = '';
  String namedata = '';
  String emaildata = '';
  String phonedata = '';
  String descdata = '';
  String webdata = '';
  bool _isObscure = false;
  String passdata = '';

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
              const Text(
                "New Company",
                style: TextStyle(
                    fontFamily: 'Ubuntu',
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
                            width: SizeConfig.screenWidth * 0.25,
                            child: buildNameFormField(),
                          ),
                        ],
                      ),
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
                      Text(passdata),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.25,
                    child: buildPasswordFormField(),
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
                      Text(descdata),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.25,
                    child: buildDescriptionFormField(),
                  ),
                  Row(
                    children: [
                      Text(webdata),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.25,
                    child: buildWebsiteFormField(),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(30),
                  ),
                  DefaultButton(
                    text: "Add Company",
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        save();
                        print("${company.name} added successfully");
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
        company.email = value;
      },
      // onSaved: (savedValue) {
      //   company.email = savedValue!;
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
        company.password = value;
      },
      // onSaved: (savedValue) {
      //   // company.password = savedValue!;
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
            phonedata = '';
          });
        }
        // company.phone = value;
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

  TextFormField buildNameFormField() {
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
        company.name = value;
      },
      // onSaved: (savedValue) {
      //   company.email = savedValue!;
      // },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        labelText: 'Name',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (Desc) {
        if (Desc == null || Desc.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            descdata = 'Please enter a short description about your company';
          });
          return "";
        } else if (Desc.isNotEmpty) {
          setState(() {
            errorImg = "assets/icons/white.svg";
            descdata = '';
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
        company.description = value;
      },
      // onSaved: (savedValue) {
      //   company.email = savedValue!;
      // },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        labelText: 'Description',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }

  TextFormField buildWebsiteFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (Website) {
        if (Website == null || Website.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            webdata = 'Enter your company website';
          });
          return "";
        } else if (!Website.startsWith('https://')) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            webdata = 'Enter valid website for your company';
          });
          return "";
        } else if (Website.isNotEmpty && Website.startsWith('https://')) {
          setState(() {
            errorImg = "assets/icons/white.svg";
            webdata = '';
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
        company.website = value;
      },
      // onSaved: (savedValue) {
      //   company.email = savedValue!;
      // },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.web,
          color: tPrimaryColor,
        ),
        labelText: 'Website',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
}
