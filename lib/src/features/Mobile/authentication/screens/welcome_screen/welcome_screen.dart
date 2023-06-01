import 'package:flutter/material.dart';
import 'package:uptrain/notifications_service.dart';
import 'package:uptrain/src/constants/image_strings.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';
import 'package:uptrain/src/utils/theme/widget_themes/button2_theme.dart';
import 'package:uptrain/src/utils/theme/widget_themes/button_theme.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/size_config.dart';
import '../splash/splash_screen.dart';
import '../student_signup/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value) {
      print('Device token:');
      print(value);
    });
    // notificationServices.isTokenfresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(children: <Widget>[
        SizedBox(
          height: getProportionateScreenHeight(100),
        ),
        Text(
          "Welcome to",
          style: bodyTextStyle,
        ),
        Text(
          tAppName,
          style: headingStyle,
        ),
        Text(
          tWelcomeSubTitle,
          style: bodyTextStyle,
        ),
        SizedBox(
          height: getProportionateScreenHeight(50),
        ),
        const Image(image: AssetImage("assets/images/welcome1.png")),
        SizedBox(
          height: getProportionateScreenHeight(50),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultButton(
                text: "Continue",
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SplashScreen()));
                }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ]),
    ));
  }
}
