import 'dart:io';

import 'package:dogly_front/dogs/screens/recognise_dog_breed.dart';
import 'package:dogly_front/home/home_screen.dart';
import 'package:dogly_front/profile/screens/profile_screen.dart';
import 'package:dogly_front/services/google_services.dart';
import 'package:dogly_front/settings/settings_screen.dart';
import 'package:dogly_front/widgets/dogly_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'dogs/bloc/dog_bloc.dart';
import 'dogs/screens/dogs_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  File? image;

  Future<Map<String, dynamic>> onUpload() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return {};
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      GoogleServices s = GoogleServices();
      var response = await s.detectObjects(imageTemp);
      return response;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      return {};
    } catch (e) {
      print(e);
      return {};
    }
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
          appBar: DoglyAppBar(),
          body: buildBody(_selectedIndex),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              String textAsset =
                  "assets/dogs_breed.txt"; //path to text file asset
              String text = await rootBundle.loadString(textAsset);
              List<String> contents = text.split("\n");
              await onUpload().then(
                (value) {
                  String detectedBreed = '';
                  Widget? widget;
                  if (value['responses'] != null &&
                      value['responses'].isNotEmpty) {
                    List<dynamic> labels =
                        value['responses'][0]['labelAnnotations'];
                    List<String> description = [];
                    for (var label in labels) {
                      description.add(label['description']);
                    }
                    for (var breed in contents) {
                      for (var desc in description) {
                        if (desc.containsIgnoreCase(breed)) {
                          detectedBreed = breed;
                        }
                      }
                    }
                    if (detectedBreed.isNotEmpty) {
                      widget = BlocProvider.value(
                        value: context.read<DogBloc>(),
                        child: RecogniseDogBreed(
                            image: image ?? File('assets/logo.png'),
                            breed: detectedBreed),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Sorry. We couldn\'t detect the breed from this picture. Try another one.",
                            style: GoogleFonts.openSans(fontSize: 16),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Okay'))
                          ],
                        ),
                      );
                    }
                  }

                  return widget != null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => widget!),
                        )
                      : null;
                },
              );
            },
            child: const Icon(Icons.image),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 15,
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                //children inside bottom appbar
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.house,
                      color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => setState(() => _selectedIndex = 0),
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.dog,
                      color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => setState(() => _selectedIndex = 1),
                  ),
                  const SizedBox(width: 50),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.solidUser,
                      color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => setState(() => _selectedIndex = 2),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 30,
                      color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => setState(() => _selectedIndex = 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return BlocProvider.value(
          value: context.read<DogBloc>(),
          child: const DogsScreen(),
        );
      case 2:
        return const ProfileScreen();

      case 3:
        return const SettingsScreen();
      default:
        return Container(color: Colors.blue);
    }
  }
}

extension StringUtils on String {
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }
}
