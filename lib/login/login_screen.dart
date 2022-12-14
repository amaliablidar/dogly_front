import 'package:dogly_front/login/register/register_screen.dart';
import 'package:dogly_front/main_page.dart';
import 'package:dogly_front/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/background.jpg",
              fit: BoxFit.fill,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  Flexible(
                    flex: 5,
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset("assets/logo.png"),
                          ),
                        ),
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
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 3,
                          child: textField(
                            "Email or Username",
                            emailController,
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: textField("Password", passwordController,
                              isObscure: true),
                        ),
                        const Spacer(),
                        Flexible(
                          flex: 3,
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                if (emailController.text.contains('@')) {
                                  await Services.login(
                                          password: passwordController.text,
                                          email: emailController.text)
                                      .then((value) {
                                    if (value["success"]) {
                                      pref.setString(
                                          "email", emailController.text);
                                      pref.setString("token", value["token"]);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomePage(),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return ErrorDialog(
                                            message: value["message"],
                                          );
                                        },
                                      );
                                    }
                                  });
                                } else {
                                  usernameController.text = emailController.text;
                                  await Services.login(
                                          password: passwordController.text,
                                          username: usernameController.text,)
                                      .then((value) {
                                    if (value["success"]) {
                                      pref.setString(
                                          "username", usernameController.text);
                                      pref.setString("token", value["token"]);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomePage(),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return ErrorDialog(
                                            message: value["message"],
                                          );
                                        },
                                      );
                                    }
                                  });
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: GoogleFonts.openSans(
                              fontSize: 14, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Sign up.',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField(String title, TextEditingController controller,
      {bool isObscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: TextFormField(
            obscureText: isObscure,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        )
      ],
    );
  }
}
