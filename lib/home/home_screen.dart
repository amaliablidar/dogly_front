import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            "assets/background.jpg",
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(backgroundColor: Colors.transparent, body: Container())
      ],
    );
  }
}
