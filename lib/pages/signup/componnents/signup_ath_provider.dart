import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_order/pages/home/home_page.dart';
import 'package:food_order/route/routing_page.dart';

class SignupAuthProvider with ChangeNotifier {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regex = RegExp(SignupAuthProvider.pattern.toString());
  UserCredential? userCredential;
  bool loading = true;

  void signupValidation(
      {required TextEditingController? fullName,
      required TextEditingController? emailadress,
// ignore: non_constant_identifier_names
      required TextEditingController? Password,
      required BuildContext context}) async {
    if (fullName!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Full Name is empty"),
        ),
      );
      return;
    } else if (emailadress!.text.trim().isEmpty) {
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
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailadress.text,
          password: Password.text,
        );
        loading = true;
        notifyListeners();
        FirebaseFirestore.instance
            .collection("user")
            .doc(userCredential!.user!.uid)
            .set(
          {
            "fullname": fullName.text,
            "emailadress": emailadress.text,
            "password": Password.text,
            "userUid": userCredential!.user!.uid,
            "isAdmin":false,
          },
        ).then((value) {
          loading = false;
          notifyListeners();
          RoutingPage.gotonext(
            context: context,
            navigateTo: HomePage(),
          );
        });
      } on FirebaseAuthException catch (e) {
        loading = false;
        notifyListeners();
        if (e.code == "weak password") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("weak password"),
            ),
          );
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("email-already-in-use"),
            ),
          );
        }
      }
    }
  }
}
