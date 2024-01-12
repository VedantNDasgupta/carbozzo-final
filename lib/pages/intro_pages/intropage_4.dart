import 'package:flutter/material.dart';

class IntroPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("lib/images/4.png"), fit: BoxFit.cover),
      ),
    );
  }
}
