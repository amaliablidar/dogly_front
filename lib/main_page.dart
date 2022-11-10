import 'package:dogly_front/home/home_screen.dart';
import 'package:dogly_front/profile/screens/profile_screen.dart';
import 'package:dogly_front/settings/settings_screen.dart';
import 'package:dogly_front/widgets/dogly_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
            onPressed: () {},
            child: const Icon(Icons.camera_alt_rounded),
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
        return Container(color: Colors.yellow);
      case 2:
        return const ProfileScreen();

      case 3:
        return const SettingsScreen();
      default:
        return Container(color: Colors.blue);
    }
  }
}
