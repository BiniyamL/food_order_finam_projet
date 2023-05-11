import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/model/user_model.dart';
import 'package:food_order/pages/CartPage/cart_page.dart';
import 'package:food_order/pages/favorite/favorite_page.dart';
import 'package:food_order/pages/home/home_page.dart';
import 'package:food_order/pages/login/login_page.dart';
import 'package:food_order/pages/orders/my_orders_page.dart';
import 'package:food_order/pages/profile/profile_page.dart';
import 'package:food_order/route/routing_page.dart';

class BuildDrawer extends StatelessWidget {
  
  const BuildDrawer({Key? key,}) : super(key: key);

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
                navigateTo: CartPage (),
              );
            },
            leading: Icon(
              Icons.shopping_cart_rounded,
            ),
            title: Text("Cart"),
          ),
          ListTile(
            onTap: () {
              RoutingPage.gotonext(
                context: context,
                navigateTo: FavoritePage(),
              );
            },
            leading: Icon(
              Icons.favorite,
            ),
            title: Text("Favorite"),
          ),
          ListTile(
            onTap: () {
              RoutingPage.gotonext(
                context: context,
                navigateTo: MyOrdersPage(),
              );
            },
            leading: Icon(
              Icons.shopping_basket_sharp,
            ),
            title: Text("My Order"),
          ),
          ListTile(
            onTap: () {
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
