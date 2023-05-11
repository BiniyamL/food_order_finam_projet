import 'package:flutter/material.dart';
import 'package:food_order/pages/signup/signup_page.dart';
import 'package:food_order/route/routing_page.dart';
import 'package:food_order/widgets/my_button.dart';

class EndPart extends StatelessWidget {
  final void Function()? onPressed;
  final bool loading;

  const EndPart({required this.loading, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        loading == true
            ? CircularProgressIndicator()
            : MyButton(
                onPressed: onPressed,
                text: "LOG IN",
              ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?\t\t\t"),
            GestureDetector(
                onTap: () {
                  RoutingPage.gotonext(
                    context: context,
                    navigateTo: SignUpPage(),
                  );
                },
                child: Text("SIGN UP")),
          ],
        ),
      ],
    );
  }
}
