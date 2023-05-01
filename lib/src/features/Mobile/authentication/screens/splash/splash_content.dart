import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/text.dart';
import '../../../../../constants/size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
         SizedBox(
                      height: getProportionateScreenHeight(60),
                    ),
        Text(
          "UPTRAIN",
          style: headingStyle,
        ),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
          style: bodyTextStyle,
        ),
      ],
    );
  }
}
