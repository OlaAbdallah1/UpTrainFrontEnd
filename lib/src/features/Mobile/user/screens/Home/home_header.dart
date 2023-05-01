import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Home/search_field.dart';

import '../../../../../constants/size_config.dart';
import 'icon_btn.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
          const SearchField(),
          const SizedBox(
            width: 10
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: 3,
            press: () {},
          ),
          const SizedBox(
            width: 10
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Chat bubble Icon.svg",
            numOfitem: 1,
            press: () {},
          ),
        ],
      ),
    );
  }
}
