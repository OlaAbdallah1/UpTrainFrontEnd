import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/size_config.dart';
import '../../../authentication/models/field.dart';
import '../../../authentication/models/user.dart';

class ProfilePic extends StatefulWidget {
  final User user;

  const ProfilePic({
    super.key,
    required this.user,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePicFormState createState() => _ProfilePicFormState();
}

class _ProfilePicFormState extends State<ProfilePic> {
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

  // User user = User(
  //     firstName: '',
  //     lastName: '',
  //     email: '',
  //     password: '',
  //     phone: '',
  //     field_id: 0,
  //     skills: '',
  //     picture: '');
  // void save() async {
  //   try {
  //     if (image != null) {
  //       final cloudinary = CloudinaryPublic('dsmn9brrg', 'ul29zf8l');

  //       CloudinaryResponse resImage = await cloudinary.uploadFile(
  //         CloudinaryFile.fromFile(image!.path, folder: user.firstName),
  //       );
  //       setState(() {
  //         imageUrl = resImage.secureUrl;
  //         user.picture = imageUrl;
  //       });
  //     } else {
  //       setState(() {
  //         user.picture =
  //             const Image(image: AssetImage("assets/images/profile.png"))
  //                 as String;
  //       });
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          ClipOval(child: Image.asset('assets/images/${widget.user.photo}')),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  primary: Colors.white,
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  myAlert();
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
