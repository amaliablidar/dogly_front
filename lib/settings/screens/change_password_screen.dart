import 'package:dogly_front/widgets/simple_dogly_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/services.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();
  List<TextEditingController> controllers = [];

  bool isFormValid = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  bool? validateForm() {
    controllers = [oldPassword, newPassword, confirmNewPassword];
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        setState(() => isFormValid = false);
        return false;
      } else {
        if (confirmNewPassword.text != newPassword.text) {
          setState(() => isFormValid = false);
          return false;
        }
      }
    }
    setState(() => isFormValid = true);
    return true;
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
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: SimpleDoglyAppBar(context: context),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      onChanged: validateForm,
                      child: Column(
                        children: [
                          textField("Old Password", oldPassword, isObscure: true),
                          textField("New Password Password", newPassword,
                              isObscure: true),
                          textField("Confirm New Password", confirmNewPassword,
                              isObscure: true,  onValidate: (value) {
                              if (value != newPassword.text) {
                                return false;
                              } else {
                                return true;
                              }
                            },),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: isLoading
                      ? Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ))
                      : ElevatedButton(
                          onPressed: isFormValid
                              ? () async {
                                  if (isLoading) {
                                    return;
                                  } else {
                                    setState(() => isLoading = true);
                                    var instance =
                                        await SharedPreferences.getInstance();
                                    String? username =
                                        instance.getString("username");
                                    String? email =
                                    instance.getString("email");
                                    await Services.resetPassword(
                                      username ?? '',
                                      oldPassword.text,
                                      newPassword.text,
                                      email,
                                    ).then(
                                      (value) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(value),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Okay'),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    setState(() => isLoading = false);
                                  }
                                }
                              : null,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Reset Password',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget textField(String title, TextEditingController controller,
      {bool Function(String)? onValidate, bool isObscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            isDense: true,
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
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is required.";
            }
            if (onValidate != null) {
              if (!onValidate(value)) {
                return "Your passwords don't match.";
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
