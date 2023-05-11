import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_order/pages/orders/orders_details_page.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Orders"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collectionGroup("userOrders").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orders = snapshot.data!.docs;
            if (orders.isNotEmpty) {
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index].data();
                   final orderRef = orders[index].reference;
                  return ListTile(
  title: Text("Order ID: ${order["email"]}"),
  subtitle: Text("Total Price: ${order["totalPrice"]}"),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
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
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          orderRef.delete();
          // FirebaseFirestore.instance
          //   .collectionGroup("userOrders")
          //  .doc(orders[index].reference.path)
          //   .delete();
        },
      ),
    ],
  ),
);

                },
              );
            } else {
              return Center(child: Text("No orders found"));
            }
          } else {
            return Center(child: Text("NO Order"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOrderDialog(context),
        child: Icon(Icons.search),
      ),
    );
  }

  Future<void> _showOrderDialog(BuildContext context) async {
    final orderIdController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Find Order"),
        content: TextField(
          controller: orderIdController,
          decoration: InputDecoration(
            hintText: "Enter Order ID",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final orderId = orderIdController.text;
              if (orderId.isNotEmpty) {
                  FirebaseFirestore.instance
                  .collectionGroup("userOrders")
                  .where("orderId", isEqualTo: orderId)
                  .get()
                    .then((querySnapshot) {
                  if (querySnapshot.docs.isNotEmpty) {
                    final orderData = querySnapshot.docs.first.data();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(orderData: orderData),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Order not found"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                });
              }
            },
            child: Text("Find"),
          ),
        ],
      ),
    );
  }
}
