import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoglyAppBar extends AppBar {
  DoglyAppBar({Key? key})
      : super(
          key: key,
          elevation: 0,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 55,
                width: 55,
                child: Image.asset("assets/logo.png"),
              ),
              const SizedBox(width: 20),
              RichText(
                text: TextSpan(
                  text: 'Dogly',
                  style: GoogleFonts.dmSans(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: '.',
                      style: GoogleFonts.dmSans(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffBE9EFF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
}
