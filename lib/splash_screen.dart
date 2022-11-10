import 'dart:async';

import 'package:dogly_front/home/home_screen.dart';
import 'package:dogly_front/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  String? email;
  String? username;



  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      email=value.getString("email");
      username=value.getString("username");
      timer = Timer(
        const Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => email!=null||username != null? const HomePage():const LoginScreen(),
          ),
        ),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
            )),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/logo.png"))),
              RichText(
                text: TextSpan(
                  text: 'Dogly',
                  style: GoogleFonts.dmSans(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: '.',
                      style: GoogleFonts.dmSans(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffBE9EFF),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
