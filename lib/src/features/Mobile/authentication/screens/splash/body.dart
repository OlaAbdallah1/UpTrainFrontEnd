import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/image_strings.dart';
import 'package:uptrain/src/constants/text.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/size_config.dart';
import '../../../../../utils/theme/widget_themes/button2_theme.dart';
import '../../../../../utils/theme/widget_themes/button_theme.dart';
import '../login/login_screen.dart';
import '../student_signup/sign_up_screen.dart';
import 'splash_content.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": tSplashSubTitle1,
      "image": tSplashImage1
    },
    {
      "text":
         tSplashSubTitle2,
      "image": tSplashImage2
    },
    {
      "text": tSplashSubTitle3,
      "image": tSplashImage3
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(30),
                    ),
                    DefaultButton(
                      text: "Login".toUpperCase(),
                      press: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(14),
                    ),
                    Button2(
                      text: "Sign Up".toUpperCase(),
                      press: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                      },
                      child: Text("data"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: tAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? tPrimaryColor : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
