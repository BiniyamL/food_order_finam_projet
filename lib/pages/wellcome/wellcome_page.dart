import 'package:flutter/material.dart';

import 'components/center_part.dart';
import 'components/end_part.dart';
import 'components/top_part.dart';

class WellcomePage extends StatelessWidget {
  const WellcomePage({Key?key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(

body: SafeArea(
  child:Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
  child:Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children:  [
       TopPart(),
       CenterPart(),
       EndPart(),
    ],
    ) ,

    ),

    ),
    );
  }
}