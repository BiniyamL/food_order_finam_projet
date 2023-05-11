import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/pages/orders/orders_details_page.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("userOrders")
            .orderBy("orderDate", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orders = snapshot.data!.docs;
            if (orders.isNotEmpty) {
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index].data();
                  return ListTile(
                    title: Text("Order ID: ${order["orderId"]}"),
                    subtitle: Text("Total Price: ${order["totalPrice"]}"),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                       Navigator.push(
                            context,
                            MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(orderData: order),
  ),
);

                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("You haven't placed any orders yet"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
