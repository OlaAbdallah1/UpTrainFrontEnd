import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Home/branches.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Home/programs.dart';

import 'home_header.dart';
import 'recommended.dart';

class Body extends StatelessWidget {
   User user = User(id: 0, email: '', password: '', firstName: '', lastName: '', phone: '', picture: '', field: 0, skills: '');
   Body({super.key, 
  //  required this.user
   });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                const HomeHeader(),
                            //  Text(user.email),
                SizedBox(height: getProportionateScreenHeight(10)),
                Branches(),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Text(
                      "Recommended for you ",
                      style: TextStyle(
                          fontSize: getProportionateScreenHeight(18),
                          color: tPrimaryColor,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                const Recommended(),

                // SizedBox(
                //   height: getProportionateScreenHeight(10),
                // ),
                // const Divider(
                //   height: 1.5,
                //   thickness: 1.5,
                //   color: Colors.grey,
                // ),

                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(12),
                        ),
                        Text(
                          "All Programs ",
                          style: TextStyle(
                              // decoration: TextDecoration.underline,
                              fontSize: getProportionateScreenHeight(18),
                              color: tPrimaryColor,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    // SizedBox(
                    //   width: getProportionateScreenWidth(
                    //       SizeConfig.screenWidth * 0.22),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Column(
                    //       children: [
                    //         SizedBox(height: 20,),
                    //     TextButton(
                    //         onPressed: () {},
                    //         child: const Text(
                    //           "All Programs",
                    //           style: TextStyle(
                    //               color: Color.fromARGB(255, 55, 63, 78),
                    //               decoration: TextDecoration.underline,
                    //               fontSize: 16),
                    //         ))
                    //       ],
                    //     )

                    //   ],
                    // ),
                  ],
                ),
                const ProgramPage()
// Branches(),
                // SizedBox(height: SizeConfig.screenHeight * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
