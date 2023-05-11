import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/appcolors/app_colors.dart';
import 'package:food_order/pages/provider/cart_provider.dart';
import 'package:food_order/widgets/my_button.dart';
import 'package:food_order/widgets/single_cart_item.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {

    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();
double subTotal=cartProvider.subTotal();
double discount=5;


double discountValue=(subTotal*discount)/100 ;
double value= subTotal-discountValue;

       double totalPrice  =value;

if(cartProvider.getCartList.isEmpty){
  setState(() {
    totalPrice=0.0;
  });
}




    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "check out",
          style: TextStyle(
            color: AppColors.kblackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child:cartProvider.getCartList.isEmpty
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
          ),
          Expanded(
              child: Column(
            children: [
              ListTile(
                leading: Text("Sub Total"),
                trailing: Text("$subTotal Birr"),
              ),
              ListTile(
                leading: Text("Discount"),
                trailing: Text("5%"),
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                leading: Text("Total"),
                trailing: Text(" $totalPrice Birr"),
              ),
              cartProvider.getCartList.isEmpty
          ? Text("")
             : MyButton(
         onPressed: () {
  // Create a new document with a unique ID in the user's orders collection
  DocumentReference orderDocRef = FirebaseFirestore.instance
      .collection("orders")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("userOrders")
      .doc();

  // Build the order data
  Map<String, dynamic> orderData = {
     "email": FirebaseAuth.instance.currentUser!.email,
    "orderId": orderDocRef.id,
    "orderDate": DateTime.now(),
    "products": cartProvider.getCartList.map((item) => {
      "productId": item.productId,
      "productName": item.productName,
      "productImage": item.productImage,
      "productPrice": item.productPrice,
      "productQuantity": item.productQuantity,
    }).toList(),
    "totalPrice": totalPrice,

  };

  // Add the order data to the new document
  orderDocRef.set(orderData)
      .then((value) => print("Order added to Firestore"))
      .catchError((error) => print("Failed to add order: $error"));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Order added successfully!"),
    ));


                }, text: 'Buy',),
            ],
          )),
        ],
      ),
    );
  }
}
