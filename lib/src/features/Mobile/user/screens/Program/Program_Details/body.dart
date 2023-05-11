import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../company/profile/company_profile_screen.dart';
import '../../trainer/profile/trainer_profile_screen.dart';

class Body extends StatelessWidget {
  //  final Trainer _trainer = Trainer(
  //     email: '',
  //     password: '',
  //     first_name: '',
  //     last_name: '',
  //     phone_number: '',
  //     photo: '',
  //     company_id: 0);

  late final String title;
  late final String image;
  late final String details;
  late final String company;
  late final String startDate;
  late final String endDate;
  String trainer;

  Body(
      {required this.title,
      required this.image,
      required this.details,
      required this.company,
      required this.startDate,
      required this.endDate,
      required this.trainer});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipOval(
                child: ImageFromUrl(imageUrl: image),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyAccount(
                                companyName: company,
                                
                              )));
                },
                child: Text(
                  company,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getProportionateScreenHeight(24),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                      color: tPrimaryColor),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Text(
                title,
                style: TextStyle(
                    fontSize: getProportionateScreenHeight(24),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: tPrimaryColor),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text(
                "Program Details: ",
                style: TextStyle(
                    color: tPrimaryColor,
                    fontSize: 20,
                    fontFamily: 'Ubuntu',
                    decoration: TextDecoration.underline),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                details.splitMapJoin('.'),
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(16),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text("Duration",
                  style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      decoration: TextDecoration.underline)),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "$startDate - $endDate",
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(18),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              const Text("Trainer",
                  style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      decoration: TextDecoration.underline)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrainerAccount(
                                    trainer: trainer,
                                  )));
                    },
                    child: Text(
                      trainer,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: getProportionateScreenHeight(18),
                          fontFamily: 'Ubuntu',
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
