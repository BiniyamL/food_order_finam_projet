import 'package:flutter/material.dart';
import 'package:food_order/appcolors/app_colors.dart';
import 'package:food_order/pages/login/login_page.dart';
import 'package:food_order/pages/signup/signup_page.dart';
import 'package:food_order/route/routing_page.dart';

import '../../../widgets/my_button.dart';

class EndPart extends StatelessWidget {
  const EndPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyButton(
          onPressed: () {
             RoutingPage.gotonext(
              context: context,
              navigateTo: LoginPage(),
            );
          },
          text: 'LOG IN',
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            RoutingPage.gotonext(
              context: context,
              navigateTo: SignUpPage(),
            );
          },
          child: Text(
            "SIGN UP",
            style: TextStyle(color: AppColors.kgreyColor),
          ),
        )
      ],
    );
  }
}
