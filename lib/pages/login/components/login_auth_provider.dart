import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_order/pages/home/admin_page.dart';
import 'package:food_order/pages/home/home_page.dart';
import 'package:food_order/route/routing_page.dart';

class LoginAuthProvider with ChangeNotifier {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regex = RegExp(LoginAuthProvider.pattern.toString());

  bool loading = false;
  UserCredential? userCredential;

  void loginPageValidation(
      {required TextEditingController? emailadress,
// ignore: non_constant_identifier_names
      required TextEditingController? Password,
      required BuildContext context}) async {
    if (emailadress!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email adress is empty"),
        ),
      );
      return;
    } else if (!regex.hasMatch(emailadress.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(" Invalid Email adress "),
        ),
      );
      return;
    } else if (Password!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("password is empty"),
        ),
      );
      return;
    } else if (Password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("password must be 8"),
        ),
      );
      return;
    } else {
      try {
        loading = true;
        notifyListeners();
        
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailadress.text,
          password: Password.text,
        );
         var userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential!.user!.uid)
            .get();


              var userData = userDoc.data();
        var isAdmin = userData?['isAdmin'] ?? false;

         loading = false;
        notifyListeners();
          if (isAdmin) {
          await RoutingPage.gotonext(
            context: context,
            navigateTo: AdminHomePage(),
          );
        } else {
          await RoutingPage.gotonext(
            context: context,
            navigateTo: HomePage(),
          );
        }
        //     .then(
        //   (value) async {
        //     loading = false;
        //     notifyListeners();



        //     await RoutingPage.gotonext(
        //       context: context,
        //       navigateTo: HomePage(),
        //     );
        //   },
        // );
        loading = false;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        loading = false;
        notifyListeners();
        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("user-not-found"),
            ),
          );
        } else if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("wrong-password"),
            ),
          );
        }
      }
    }
  }
}
