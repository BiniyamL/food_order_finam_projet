import 'package:flutter/material.dart';
import 'package:food_order/pages/login/components/center_part.dart';
import 'package:food_order/pages/login/components/end_part.dart';
import 'package:food_order/pages/login/components/login_auth_provider.dart';
import 'package:food_order/pages/login/components/top_part.dart';

import 'package:food_order/widgets/my_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    LoginAuthProvider loginAuthProvider =
        Provider.of<LoginAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
          automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ///top part
            TopPart(),
            //center part
            CenterPart(
              email: email,
              Password: password,
              obscureText: visible,
              icon: Icon(
               visible? Icons.visibility_off:Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  visible = !visible;
                });
              },
            ),
            //end part

            EndPart(
              loading: loginAuthProvider.loading,
              onPressed: () {
                loginAuthProvider.loginPageValidation(
                  emailadress: email,
                  Password: password,
                  context: context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
