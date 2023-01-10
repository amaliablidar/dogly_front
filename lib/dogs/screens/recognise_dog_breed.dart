import 'dart:io';

import 'package:dogly_front/dogs/bloc/dog_bloc.dart';
import 'package:dogly_front/dogs/screens/add_dog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../profile/models/user_notifier.dart';

class RecogniseDogBreed extends StatelessWidget {
  const RecogniseDogBreed({Key? key, required this.image, required this.breed})
      : super(key: key);
  final String breed;
  final File image;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/background.jpg",
          fit: BoxFit.fill,
        ),
      ),
      SafeArea(
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Container(
                            height: 500,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        flex: 4,
                        child: Text.rich(
                            TextSpan(
                              text: 'The recognised dog breed is:\n',
                              style: GoogleFonts.openSans(fontSize: 20),
                              children: [
                                TextSpan(
                                  text: breed,
                                  style: GoogleFonts.mali(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 10,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              )),
                        )),
                    const Spacer(),
                    Expanded(
                        flex: 10,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<DogBloc>(),
                                        child: AddDogScreen(
                                          breed: breed,
                                          image: image,
                                        ),
                                      ),
                                    ),
                                  ),
                              child: const Text('Add',
                                  style: TextStyle(fontSize: 16))),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
