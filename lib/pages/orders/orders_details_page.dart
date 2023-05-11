import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsPage({Key? key, required this.orderData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

        Timestamp timestamp = orderData["orderDate"];

    DateTime date = timestamp.toDate();

    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Order ID: ${orderData["orderId"]}"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Order Date: ${DateFormat('dd/MM/yyyy').format(date) }    ${difference.inHours}hr   ${ difference.inMinutes}min",
                style: TextStyle(fontSize: 18),
              ),
            ),
          
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Order Items:"),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderData["products"].length,
              itemBuilder: (context, index) {
                final product = orderData["products"][index];
                return ListTile(
                  title: Text(product["productName"]),
                  subtitle: Text("${product["productQuantity"]} x ${product["productPrice"]}"),
                  trailing: Text("${product["productQuantity"] * product["productPrice"]}"),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Total Price: ${orderData["totalPrice"]}"),
            ),
          ],
        ),
      ),
    );
  }
}
