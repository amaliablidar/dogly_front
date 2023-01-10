import 'package:dogly_front/dogs/screens/add_dog_screen.dart';
import 'package:dogly_front/dogs/screens/dog_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../profile/models/user_notifier.dart';
import '../bloc/dog_bloc.dart';

class DogsScreen extends StatelessWidget {
  const DogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Dogs",
                  style: GoogleFonts.openSans(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<DogBloc>(context),
                              child: const AddDogScreen(),
                            ),
                          ),
                        ),
                    icon:
                        Icon(Icons.add, color: Theme.of(context).primaryColor)),
              ],
            ),
            BlocBuilder<DogBloc, DogState>(builder: (context, state) {
              if (state is DogsLoaded) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height-320,
                        child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<DogBloc>(context),
                                    child:
                                        DogDetailScreen(dog: state.dogs[index]),
                                  ),
                                ),
                              ),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.dogs[index].name,
                                      style: GoogleFonts.mali(fontSize: 16),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff5C5C5C),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: state.dogs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return const SizedBox();
              }
            })
          ],
        ),
      ),
    );
  }
}
