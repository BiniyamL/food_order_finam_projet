import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/model/user_model.dart';
import 'package:food_order/pages/CartPage/cart_page.dart';
import 'package:food_order/pages/home/home_page.dart';
import 'package:food_order/pages/login/login_page.dart';
import 'package:food_order/pages/orders/user_orders.dart';
import 'package:food_order/pages/profile/profile_page.dart';
import 'package:food_order/route/routing_page.dart';

class AdminBuildDrawer extends StatelessWidget {
  final UserModel userModel;

  const AdminBuildDrawer({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            accountName: Text(userModel.fullName),
            accountEmail: Text(userModel.emailadress),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("images/nonprofile1.jpg"),
            ),
          ),
          ListTile(
            onTap: () {
              RoutingPage.gotonext(
                context: context,
                navigateTo: ProfilePage(),
              );
            },
            leading: Icon(
              Icons.person,
            ),
            title: Text("Profile"),
          ),
        
        
          ListTile(
            onTap: () {
              RoutingPage.gotonext(
                context: context,
                navigateTo: AdminOrdersPage(),
              );
            },
            leading: Icon(
              Icons.shopping_basket_sharp,
            ),
            title: Text("User Orders"),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              RoutingPage.gotonext(
                context: context,
                navigateTo: LoginPage(),
              );
            },
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
