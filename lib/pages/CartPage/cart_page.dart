import 'package:flutter/material.dart';
import 'package:food_order/pages/checkout/check_out_page.dart';
import 'package:food_order/pages/provider/cart_provider.dart';
import 'package:food_order/route/routing_page.dart';
import 'package:food_order/widgets/my_button.dart';
import 'package:food_order/widgets/single_cart_item.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();
    return Scaffold(
      bottomNavigationBar: cartProvider.getCartList.isEmpty
          ? Text("")
          : MyButton(
              text: "Check out",
              onPressed: () {
                RoutingPage.gotonext(
                  context: context,
                  navigateTo: CheckOutPage(),
                );
              },
            ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: cartProvider.getCartList.isEmpty
          ? Center(
              child: Text("No Product"),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: cartProvider.getCartList.length,
              itemBuilder: (ctx, index) {
                var data = cartProvider.cartList[index];
                return SingleCartItem(
                  productId: data.productId,
                  productCategory: data.productCategory,
                  productImage: data.productImage,
                  productPrice: data.productPrice,
                  productQuantity: data.productQuantity,
                  productName: data.productName,
                );
              },
            ),
    );
  }
}
