import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/colors.dart';

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    iconTheme: const IconThemeData(
      color: tPrimaryColor, //change your color here
    ),
    centerTitle: true,
    title: Text(
      "Uptrain".toUpperCase(),
      style: const TextStyle(
          color: tPrimaryColor,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'Ubuntu'),
    ),
    actions: <Widget>[
      Image.asset(
        "assets/images/download.png",
        color: tPrimaryColor,
      )
      // IconButton(
      //   icon: SvgPicture.asset("assets/icons/Search Icon.svg"),
      //   onPressed: () {},
      // ),
      // IconButton(onPressed: (){}, icon: SvgPicture.asset("assets/icons/Bell.svg",color: tPrimaryColor,)),
    ],
  );
}
