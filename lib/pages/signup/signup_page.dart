import 'package:flutter/material.dart';
import 'package:food_order/pages/login/login_page.dart';
import 'package:food_order/pages/signup/componnents/signup_ath_provider.dart';
import 'package:food_order/route/routing_page.dart';
import 'package:provider/provider.dart';

import '../../widgets/my_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fullName = TextEditingController();
  TextEditingController emailadress = TextEditingController();
  TextEditingController Password = TextEditingController();

  bool visibility = true;
  @override
  Widget build(BuildContext context) {
    SignupAuthProvider signupAuthProvider =
        Provider.of<SignupAuthProvider>(context);

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "SignUp",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                TextFormField(
                  controller: fullName,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                  ),
                ),
                TextFormField(
                  controller: emailadress,
                  decoration: InputDecoration(
                    hintText: "Email Adress",
                  ),
                ),
                TextFormField(
                  controller: Password,
                  obscureText: visibility,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visibility = !visibility;
                        });
                      },
                      icon: Icon(
                        visibility ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                signupAuthProvider.loading == true
                    ? MyButton(
                        onPressed: () {
                          signupAuthProvider.signupValidation(
                              fullName: fullName,
                              context: context,
                              emailadress: emailadress,
                              Password: Password);
                        },
                        text: 'SIGN UP',
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?\t\t\t'),
                GestureDetector(
                    onTap: () {
                      RoutingPage.gotonext(
                        context: context,
                        navigateTo: LoginPage(),
                      );
                    },
                    child: Text('LOGIN')),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
