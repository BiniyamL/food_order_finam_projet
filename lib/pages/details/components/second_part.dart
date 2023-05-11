import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/appcolors/app_colors.dart';
import 'package:food_order/pages/CartPage/cart_page.dart';
import 'package:food_order/route/routing_page.dart';
import 'package:food_order/widgets/my_button.dart';

class SecondPart extends StatelessWidget {
  final String productName;
  final int productPrice;
  final int productOldPrice;
  final int productRate;
  final String productDescription;
  final String productId;
  final String productImage;
  final String productCategory;

  const SecondPart({
    Key? key,
    required this.productCategory,
    required this.productImage,
    required this.productId,
    required this.productDescription,
    required this.productName,
    required this.productOldPrice,
    required this.productPrice,
    required this.productRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text("$productPrice Birr"),
              SizedBox(
                width: 20,
              ),
              Text(
                "$productOldPrice Birr",
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Divider(
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.kgradient1,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        productRate.toString(),
                        style: TextStyle(
                          color: AppColors.kwhiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            thickness: 2,
          ),
          Text(
            "Description",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            productDescription,
            style: TextStyle(),
          ),
          MyButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("cart")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("userCart")
                  .doc(productId)
                  .set(
                {

                  "productId":productId,
                  "productImage":productImage,
                  "productName":productName,
                  "productPrice":productPrice,
                  "productOldPrice":productOldPrice,
                  "productRate":productRate,
                  "productDescription":productDescription,
                  "productQuantity":1,
                  "productCategory":productCategory,
                },
              );

              RoutingPage.gotonext(
                context: context,
                navigateTo: CartPage(),
              );
            },
            text: "Add to Cart",
          ),
        ],
      ),
    );
  }
}
