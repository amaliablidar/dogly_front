import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isChanged = false;

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
          body: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Did you know..?',style: GoogleFonts.mali(fontSize: 25,fontWeight: FontWeight.bold),),
                Flexible(
                  child: ListView.builder(
                            itemBuilder: (context, index) => Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(facts[index], style: GoogleFonts.openSans(fontSize: 16),),
                                ),
                              ],
                            ),
                            itemCount: facts.length,
                          ),
                ),
              ],
            ),
          ),
              ),
      ],
    );
  }

  List<String> facts = [
    'Dogs\' sense of smell is at least 40x better than ours.',
    'Some have such good noses they can sniff out medical problems.',
    'Dogs can sniff at the same time as breathing.',
    'Your dog could be left or right-pawed',
    'Along with their noses, their hearing is super sensitive',
    'Dogs have 18 muscles controlling their ears',
    'Some are fast and could even beat a cheetah!',
    'Some dogs are incredible swimmers'
  ];
}
