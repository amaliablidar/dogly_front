import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/services.dart';
import '../bloc/dog_bloc.dart';
import '../models/dog.dart';
import '../models/vaccine.dart';

class AddDogScreen extends StatefulWidget {
  const AddDogScreen({Key? key, this.breed, this.image, this.dog})
      : super(key: key);
  final String? breed;
  final File? image;
  final Dog? dog;

  @override
  State<AddDogScreen> createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController vetPhone = TextEditingController();
  TextEditingController vetName = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController allergies = TextEditingController();

  List<String> allergiesList = [];
  List<Vaccine> vaccineList = [];

  DateFormat format = DateFormat("yyyy-MM-dd");
  bool isFormValid = false;

  bool isFormLoading = false;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool validateForm() {
    return name.text.isNotEmpty &&
        date.text.isNotEmpty &&
        breedController.text.isNotEmpty &&
        vetPhone.text.isNotEmpty &&
        vetName.text.isNotEmpty &&
        weight.text.isNotEmpty &&
        sexController.text.isNotEmpty;
  }

  @override
  void initState() {
    if (widget.dog != null) {
      name = TextEditingController(text: widget.dog!.name);
      date = TextEditingController(text: widget.dog!.dateOfBirth);
      breedController = TextEditingController(text: widget.dog!.breed);
      vetPhone = TextEditingController(text: widget.dog!.vetPhone);
      vetName = TextEditingController(text: widget.dog!.vetName);
      weight = TextEditingController(text: widget.dog!.weight);
      sexController = TextEditingController(text: widget.dog!.sex.name);
      allergiesList = widget.dog!.foodAllergies;
      vaccineList = widget.dog!.vaccines;
    } else if (widget.breed != null) {
      breedController.text = widget.breed!;
    }
    super.initState();
  }

  Future<List<String>> getBreed() async {
    String textAsset = "assets/dogs_breed.txt"; //path to text file asset
    String text = await rootBundle.loadString(textAsset);
    List<String> contents = text.split("\n");
    return contents;
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
          appBar: AppBar(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Add Dog",
              style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                if (widget.image != null)
                  Container(
                    height: 70,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.file(
                      widget.image!,
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      onChanged: () =>
                          setState(() => isFormValid = validateForm()),
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textField("Name", name),
                          textField("Date Of Birth", date, isDate: true),
                          const SizedBox(height: 10),
                          if (widget.breed == null) ...[
                            Text(
                              "Breed",
                              style: GoogleFonts.openSans(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            FutureBuilder(
                              future: getBreed(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (breedController.text.isEmpty ||
                                      !(snapshot.data as List<String>)
                                          .contains(breedController.text)) {
                                    breedController.text =
                                        (snapshot.data as List<String>).first;
                                  }
                                  return breedDropdown(
                                    snapshot.data as List<String>,
                                    breedController,
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                          if (widget.breed != null)
                            textField("Breed", breedController,
                                isReadOnly: true),
                          const SizedBox(height: 10),
                          textField("Veterinarian Name", vetName),
                          textField("Veterinarian Phone Number", vetPhone),
                          textField("Weight", weight),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sex",
                                style: GoogleFonts.openSans(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var sex in Sex.values)
                                    Expanded(
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => setState(() =>
                                                sexController.text = sex.name),
                                            child: Container(
                                              height: 25,
                                              width: 25,
                                              margin: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: sex.name ==
                                                          sexController.text
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            sex.name,
                                            style: GoogleFonts.openSans(
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Allergies",
                                style: GoogleFonts.openSans(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              FutureBuilder(
                                  future: Services.getAllergies(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<String> vaccineTypes =
                                          snapshot.data as List<String>;
                                      return allergiesDropdown(vaccineTypes,
                                          TextEditingController());
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                            ],
                          ),
                          if (allergiesList.isNotEmpty)
                            const SizedBox(height: 10),
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tileColor: Colors.white,
                                  trailing: SizedBox(
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() => allergiesList
                                                .remove(allergiesList[index]));
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.2),
                                                shape: BoxShape.circle),
                                            child: const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Colors.red,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: Text(allergiesList[index]),
                                ),
                              ),
                              itemCount: allergiesList.length,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Vaccines",
                                style: GoogleFonts.openSans(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              FutureBuilder(
                                  future: Services.getVaccineTypes(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<String> vaccineTypes =
                                          snapshot.data as List<String>;
                                      return vaccinesDropdown(vaccineTypes,
                                          TextEditingController());
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                            ],
                          ),
                          if (vaccineList.isNotEmpty)
                            const SizedBox(height: 10),
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tileColor: Colors.white,
                                  trailing: SizedBox(
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() => vaccineList
                                                .remove(vaccineList[index]));
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.2),
                                                shape: BoxShape.circle),
                                            child: const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Colors.red,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: Text(vaccineList[index].name),
                                ),
                              ),
                              itemCount: vaccineList.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: isFormLoading
                      ? null
                      : !validateForm()
                          ? () {
                              key.currentState?.validate();
                            }
                          : () async {
                              setState(() => isFormLoading = true);
                              await Future.delayed(const Duration(seconds: 1));
                              String? username = "";
                              SharedPreferences.getInstance().then(
                                (value) {
                                  username = value.getString("username");
                                  Dog dog = Dog(
                                      id: widget.dog?.id,
                                      ownerUsername: username ?? '',
                                      name: name.text,
                                      dateOfBirth: date.text,
                                      breed: breedController.text,
                                      weight: weight.text,
                                      sex: Sex.values.firstWhere((element) =>
                                          element.name == sexController.text),
                                      vetName: vetName.text,
                                      vetPhone: vetPhone.text,
                                      foodAllergies: allergiesList,
                                      vaccines: vaccineList);
                                  if (widget.dog == null) {
                                    context.read<DogBloc>().add(DogsSave(
                                        dog, () => Navigator.pop(context)));
                                  } else {
                                    context
                                        .read<DogBloc>()
                                        .add(DogsEdit(dog, () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }));
                                  }
                                },
                              );
                            },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: validateForm()
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: isFormLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Add Dog",
                                style: GoogleFonts.mali(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget textField(String title, TextEditingController controller,
      {bool isDate = false, bool validate = true, bool isReadOnly = false}) {
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
          style: TextStyle(
              color: isReadOnly ? const Color(0xff5C5C5C) : Colors.black,
              fontWeight: isReadOnly ? FontWeight.bold : FontWeight.normal),
          controller: controller,
          readOnly: isReadOnly,
          onTap: () async {
            if (isDate) {
              var dateValue = await showDatePicker(
                context: context,
                initialDate: date.text.isNotEmpty
                    ? DateTime(
                        int.parse(date.text.split('-').last),
                        int.parse(date.text.split('-')[1]),
                        int.parse(date.text.split('-').first),
                      )
                    : DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
              );
              date.text = format.format(dateValue ??
                  (date.text.isNotEmpty
                      ? DateTime(
                          int.parse(date.text.split('-').last),
                          int.parse(date.text.split('-')[1]),
                          int.parse(date.text.split('-').first))
                      : DateTime.now()));
            }
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            isDense: true,
            filled: true,
            fillColor: isReadOnly ? const Color(0xffE7E6E6) : Colors.white,
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
          validator: validate
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }
                  return null;
                }
              : null,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget vaccinesDropdown(
      List<String> vaccineTypes, TextEditingController textEditingController) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Text(
            'Select Vaccine',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: vaccineTypes
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                  ))
              .toList(),
          value: null,
          onChanged: (dynamic value) {
            if (value != null) {
              setState(() {
                try {
                  vaccineList.firstWhere((element) => element.name == value);
                } catch (e) {
                  vaccineList.add(Vaccine(
                      name: value.toString(),
                      administrationDate: "2022-12-12",
                      expirationDate: "2022-12-12",
                      type: value.toString(),
                      id: ''));
                }
              });
            }
          },
          buttonHeight: 40,
          buttonWidth: double.infinity,
          itemHeight: 50,
          searchController: textEditingController,
          dropdownMaxHeight: 200,
          searchInnerWidget: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Search for vaccine...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) =>
              item.value.toString().containsIgnoreCase(searchValue),

          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
      ),
    );
  }

  Widget allergiesDropdown(
      List<String> allergies, TextEditingController textEditingController) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Text(
            'Select Allergy',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: allergies
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                  ))
              .toList(),
          value: null,
          onChanged: (dynamic value) {
            if (value != null) {
              setState(() {
                if (!allergiesList.contains(value)) {
                  allergiesList.add(value.toString());
                }
              });
            }
          },
          buttonHeight: 40,
          buttonWidth: double.infinity,
          itemHeight: 50,
          searchController: textEditingController,
          dropdownMaxHeight: 200,
          searchInnerWidget: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Search for allergy...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) =>
              item.value.toString().containsIgnoreCase(searchValue),

          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
      ),
    );
  }

  Widget breedDropdown(
      List<String> breed, TextEditingController textEditingController) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: breedController.text,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        underline: Container(),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            breedController.text = value!;
          });
        },
        items: breed.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

enum Sex { male, female }

extension StringUtils on String {
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }
}
