import 'package:flutter/material.dart';

class CenterPart extends StatelessWidget {
  final TextEditingController? email;
  final TextEditingController? Password;
  final void Function()? onPressed;
  final Widget icon;
  final bool obscureText;
  CenterPart({
    required this.obscureText,
    required this.icon,
    required this.email,
    required this.Password,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: email,
          decoration: InputDecoration(
            hintText: "Email",
          ),
        ),
        TextFormField(
          obscureText: obscureText,
          controller: Password,
          decoration: InputDecoration(
            hintText: "Password",
            suffixIcon: IconButton(
              onPressed: onPressed,
              icon:icon
            ),
          ),
        ),
      ],
    );
  }
}
