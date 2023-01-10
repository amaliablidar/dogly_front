import 'dart:io';

import 'package:dogly_front/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/services.dart';
import '../../widgets/simple_dogly_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  List<TextEditingController> controllers = [];
  bool isLoading = false;
  File? image;

  bool? validateForm() {
    controllers = [firstName, lastName, email, password, confirmPassword];
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        setState(() => isFormValid = false);
        return false;
      } else {
        if (confirmPassword.text != password.text) {
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
            )),
        Scaffold(
          appBar: SimpleDoglyAppBar(
            context: context,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 30),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(width: 0.5)),
                                child: image != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                      child: Image.file(
                                        image!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : const SizedBox(),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await onUpload();
                              },
                              child: Center(
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(
                                          Icons.upload,
                                          size: 15,
                                        ),
                                        Text(
                                          'Upload',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Form(
                          key: formKey,
                          onChanged: validateForm,
                          child: Column(
                            children: [
                              textField("First Name", firstName),
                              textField("Last Name", lastName),
                              textField("Email", email),
                              textField("Password", password, isObscure: true),
                              textField(
                                "Confirm Password",
                                confirmPassword,
                                onValidate: (value) {
                                  if (value != password.text) {
                                    return false;
                                  } else {
                                    return true;
                                  }
                                },
                                isObscure: true,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                                    await Services.register(
                                            firstName.text,
                                            lastName.text,
                                            email.text,
                                            password.text, image)
                                        .then((value) {
                                      if (value["error"] != null) {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ErrorDialog(
                                                message: value["error"]);
                                          },
                                        );
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    });
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
                            'Sign up',
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

  Future<void> onUpload() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    } catch (e) {
      print(e);
    }
  }
}
