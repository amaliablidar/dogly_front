import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                                color: Colors.blue, shape: BoxShape.circle),
                            margin: const EdgeInsets.only(right: 20),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Username",
                                  style: GoogleFonts.openSans(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              Text('Level 2',
                                  style: GoogleFonts.openSans(fontSize: 16))
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.blue)),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Level 2',
                    style: GoogleFonts.openSans(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.separated(
                    itemBuilder: (_, index) => Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Take your dog on 5 walks',
                            style: GoogleFonts.openSans(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '4',
                              style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '/5',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    itemCount: 2,
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
