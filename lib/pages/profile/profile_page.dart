import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/pages/home/home_page.dart';
import 'package:food_order/route/routing_page.dart';
import 'package:food_order/widgets/my_button.dart';

class ProfilePage extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regex = RegExp(ProfilePage.pattern.toString());

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEdit = false;
  TextEditingController fullName =
      TextEditingController(text: userModel.fullName);
  TextEditingController emailadress =
      TextEditingController(text: userModel.emailadress);

  Widget textFromField({required String hintText}) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: ListTile(
        leading: Text(hintText),
      ),
    );

    // TextFormField(
    //   decoration: InputDecoration(
    //     filled: true,
    //     hintText: hintText,
    //     fillColor: Colors.grey[300],
    //     border: OutlineInputBorder(
    //       borderSide: BorderSide.none,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    // );
  }


  void profileValidation(
      {required TextEditingController? emailadress,
      required TextEditingController? fullName,
      required BuildContext context}) async {
    if (fullName!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("fullName is empty"),
        ),
      );
      return;
    } else if (emailadress!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email address is empty"),
        ),
      );
      return;
    } else if (!widget.regex.hasMatch(emailadress.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid email address"),
        ),
      );
      return;
    } else {
      buildUpdateProfile();
    }
  }


  Widget nonEditTextField() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("images/nonprofile1.jpg"),
              radius: 50,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        textFromField(hintText: userModel.fullName),
        SizedBox(
          height: 10,
        ),
        textFromField(hintText: userModel.emailadress),
      ],
    );
  }

  Widget editTextField() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("images/nonprofile1.jpg"),
              radius: 50,
            ),
          ],
        ),
        TextFormField(
          controller: fullName,
          decoration: InputDecoration(
            hintText: "fullName",
          ),
        ),
        TextFormField(
          controller: emailadress,
          decoration: InputDecoration(
            hintText: "emailadress",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        MyButton(
            onPressed: () {
              profileValidation(
              context: context,
              emailadress: emailadress,
              fullName: fullName,
            );
              
            },
            text: "Up date")
      ],
    );
  }

  Future buildUpdateProfile() async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
      "fullname":fullName.text,
      "emailadress":emailadress.text,



      },
    ).then((value) => RoutingPage.gotonext(context: context, navigateTo:HomePage(),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: isEdit
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isEdit = false;
                  });
                },
                icon: Icon(
                  Icons.close,
                ),
              )
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEdit = true;
              });
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Expanded(
              child: isEdit ? editTextField() : nonEditTextField(),
            ),
          ]),
        ),
      ),
    );
  }
}
