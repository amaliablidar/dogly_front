
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleDoglyAppBar extends AppBar {
  SimpleDoglyAppBar({
    Key? key,
    required BuildContext context,
  }) : super(
    key: key,
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: RichText(
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
    ),
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.black,
      ),
    ),
  );
}
