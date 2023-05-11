import 'package:flutter/material.dart';
import 'package:food_order/appcolors/app_colors.dart';

class TopPart extends StatelessWidget {
  const TopPart({Key?key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "images/logo.jpg",
                        scale: 8,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    const Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.kblackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            );
}
}