import 'package:dogly_front/services/services.dart';
import 'package:dogly_front/widgets/simple_dogly_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController email = TextEditingController();
  bool isValid = false;
  bool isLoading = false;

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
        Scaffold(
          appBar: SimpleDoglyAppBar(
            context: context,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: GoogleFonts.openSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 50,
                          child: TextFormField(
                            controller: email,
                            onChanged: (value) =>
                                setState(() => isValid = value.isNotEmpty),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
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
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: !isLoading
                      ? ElevatedButton(
                          onPressed: isValid
                              ? () async {
                                  setState(() => isLoading = true);
                                  String? response =
                                      await Services.forgotPassword(email.text);
                                  setState(() => isLoading = false);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        response ?? "Something went wrong",
                                        style:
                                            GoogleFonts.openSans(fontSize: 16),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Okay'))
                                      ],
                                    ),
                                  );
                                }
                              : null,
                          child: Text(
                            "Recover Password",
                            style: GoogleFonts.openSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(4),),
                          child:
                              const Center(child: CircularProgressIndicator(color: Colors.white,),),),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
