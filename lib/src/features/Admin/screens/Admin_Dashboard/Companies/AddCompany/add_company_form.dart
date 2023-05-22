import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/Companies/AddCompany/add_company_screen.dart';
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/Companies/companies_screen.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/connections.dart';
import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../../../../Mobile/authentication/models/location.dart';

class AddCompanyForm extends StatefulWidget {
   AddCompanyForm({super.key});
  @override
  State<AddCompanyForm> createState() => _AddCompanyFormState();
}

class _AddCompanyFormState extends State<AddCompanyForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    locations = getLocations();

    super.initState();
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
                  const SizedBox(
                    height: 12,
                  ),
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
      var response = await http.post(
          Uri.parse("http://$ip/api/admin/addCompany"),
          headers: <String, String>{
            'Context-Type': 'application/json;charset=UTF-8'
          },
          body: {
            'name': company.name,
            'email': company.email,
            'password': company.password,
            'phone': company.phone,
            'photo': company.photo,
            'description': company.description,
            'location_id': '5',
            'webSite': company.website,
          });

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Company'),
            content: Text("${company.name} Added Successfully"),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CompaniesScreen(
                                
                              ))),

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${company.name} Company Added'))),
                },
                child: Text('Ok',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(8),
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        );
      }
      print(response.statusCode);

      print("final error : jaym " + response.body);

      print(json.encode(company.toJson()));
      print(response.statusCode);

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
      phone: '',
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

  int locationChooseint = 0;
  List locationsList = [];

  List<Location> locationsData = [];
  late Future<List<Location>> locations;
  Future<List<Location>> getLocations() async {
    String url = "http://$ip/api/getLocations";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    // json.decode(response.body);

    if (response.statusCode == 201) {
      for (Map field in responseData) {
        locationsData.add(Location.fromJson(field));
      }
      print(locationsData);
      return locationsData;
    } else {
      return locationsData;
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
                        ? ClipOval(
                            child: Image.network(image!.path),
                          )
                        : ClipOval(
                            child: Image.network(company.photo),
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
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.25,
                    child: FutureBuilder(
                        future: locations,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            locationsList = snapshot.data!;
                            return FormBuilder(
                              child: FormBuilderDropdown<dynamic>(
                                decoration: const InputDecoration(
                                  labelText: 'Select company country',
                                  labelStyle: TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Icons.location_city,
                                    color: tPrimaryColor,
                                  ),
                                ),
                                onChanged: (dynamic newLocation) {
                                  setState(() {
                                    locationChooseint = (newLocation.id);
                                    company.location_id =
                                        int.parse(newLocation.id);
                                    print(company.location_id);
                                  });
                                },
                                // valueTransformer: (dynamic value) => value.id,
                                items: locationsList
                                    .map((location) => DropdownMenuItem(
                                        value: location,
                                        child: Text(location.name)))
                                    .toList(),
                                name: '',
                              ),
                            );
                          }
                          print("No locations");
                          return const CircleAvatar();
                        }),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
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
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.20,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: tPrimaryColor,
                        side: const BorderSide(
                          width: 1.5,
                          color: tLightColor,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          save();
                        } else {
                          print("not oky");
                        }
                      },
                      child: Text(
                        "Add Company",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Ubuntu'),
                      ),
                    ),
                  )
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
        company.phone = value;
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
