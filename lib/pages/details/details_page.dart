import 'package:flutter/material.dart';
import 'package:food_order/pages/details/components/second_part.dart';
import 'package:food_order/pages/details/components/top_part.dart';

class DetailsPage extends StatelessWidget {
  final String productImage;
  final String productName;
  final int productPrice;
  final int productOldPrice;
  final int productRate;
  final String productDescription;
  final String productId;
  final String productCategory;

  const DetailsPage({
    Key? key,
    required this.productCategory,
    required this.productId,
    required this.productImage,
    required this.productDescription,
    required this.productName,
    required this.productOldPrice,
    required this.productPrice,
    required this.productRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopPart(
              productImage: productImage,
            ),
            SecondPart(
              productCategory: productCategory,
              productImage: productImage,
              productId: productId,
              productName: productName,
              productOldPrice: productOldPrice,
              productPrice: productPrice,
              productRate: productRate,
              productDescription: productDescription,
      
            ),
          ],
        ),
      ),
    );
  }
}
