import 'package:dogly_front/dogs/bloc/dog_bloc.dart';
import 'package:dogly_front/dogs/screens/add_dog_screen.dart';
import 'package:dogly_front/dogs/screens/step_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dog.dart';

class DogDetailScreen extends StatefulWidget {
  const DogDetailScreen({Key? key, required this.dog}) : super(key: key);
  final Dog dog;

  @override
  State<DogDetailScreen> createState() => _DogDetailScreenState();
}

class _DogDetailScreenState extends State<DogDetailScreen> {
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(
                                  "Are you sure you want to delete ${widget.dog.name}?"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel")),
                                TextButton(
                                  onPressed: () async {
                                    setState(() => isLoading = true);
                                    context.read<DogBloc>().add(DogsDelete(() {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }, widget.dog.id ?? ''));
                                  },
                                  child: const Text("Yes"),
                                )
                              ],
                            ));
                  },
                ),
              )
            ],
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                )),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/logo.png"),
                    ),
                    const SizedBox(width: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.dog.name,
                          style: GoogleFonts.mali(fontSize: 25),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<DogBloc>(context),
                                child: AddDogScreen(dog: widget.dog),
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.blue)),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const StepCounter())),
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                          text: "Take ",
                                          style: GoogleFonts.openSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text: widget.dog.name,
                                              style: GoogleFonts.mali(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: " on a walk",
                                              style: GoogleFonts.openSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ]),
                                    ),
                                    Text(
                                      "Count your steps to win the challenges",
                                      style: GoogleFonts.openSans(fontSize: 12),
                                    )
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xff5C5C5C),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        dogDetail("Date of Birth",
                            value: widget.dog.dateOfBirth),
                        dogDetail("Breed", value: widget.dog.breed),
                        dogDetail("Sex", value: widget.dog.sex.name),
                        dogDetail("Veterinarian Name",
                            value: widget.dog.vetName),
                        dogDetail("Veterinarian Phone",
                            value: widget.dog.vetPhone),
                        dogDetail("Weight", value: "${widget.dog.weight} g"),
                        if (widget.dog.foodAllergies.isNotEmpty)
                          dogDetail("Allergies",
                              values: widget.dog.foodAllergies),
                        if (widget.dog.vaccines.isNotEmpty)
                          dogDetail("Vaccines",
                              values: widget.dog.vaccines
                                  .map((e) => e.name)
                                  .toList()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dogDetail(String title, {String? value, List<String>? values}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.mali(fontSize: 16),
          ),
          if (value != null)
            Text(
              value,
              style: GoogleFonts.openSans(fontSize: 16),
            )
          else if (values != null && values.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                  values.length,
                  (index) => Text(
                        values[index],
                        style: GoogleFonts.openSans(fontSize: 16),
                        textAlign: TextAlign.right,
                      )),
            )
        ],
      ),
    );
  }
}
