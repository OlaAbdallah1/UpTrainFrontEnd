// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';

class Button2 extends StatelessWidget {
  const Button2({
    Key? key,
    this.text,
    this.press,
    required Text child,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: getProportionateScreenHeight(50),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: tLightColor,
          side: const BorderSide(
            width: 1.5,
            color: tPrimaryColor,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Ubuntu',
            color: tPrimaryColor,
          ),
        ),
      ),
    );
  }
}
