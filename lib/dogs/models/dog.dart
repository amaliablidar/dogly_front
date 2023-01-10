import 'package:dogly_front/dogs/models/vaccine.dart';

import '../screens/add_dog_screen.dart';

class Dog {
  final String? id;
  final String name;
  final String dateOfBirth;
  final String breed;
  final String weight;
  final Sex sex;
  final String vetName;
  final String vetPhone;
  final String ownerUsername;
  final List<String> foodAllergies;
  final List<Vaccine> vaccines;

  Dog({
     this.id,
    required this.name,
    required this.dateOfBirth,
    required this.breed,
    required this.weight,
    required this.sex,
    required this.vetName,
    required this.vetPhone,
    required this.ownerUsername,
    required this.foodAllergies,
    required this.vaccines,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"]=id??1;
    json['birthday'] = dateOfBirth;
    json['breed'] = breed;
    json['name'] = name;
    json['weight'] = weight;
    json['sex'] = sex.name.toUpperCase();
    json['vetName'] = vetName;
    json['vetMobileNr'] = vetPhone;
    json['ownerUsername'] = ownerUsername;
    json['foodAllergies'] = foodAllergies;
    json['vaccines'] = vaccines.map((e) => e.toJson()).toList();
    return json;
  }

  Dog.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        dateOfBirth = json['birthday'],
        breed = json['breed'],
        weight = json['weight'],
        sex = Sex.values
            .where((element) =>
                element.name == (json['sex']).toString().toLowerCase())
            .first,
        vetName = json['vetName'],
        vetPhone = json['vetMobileNr'],
        ownerUsername = json['ownerUsername'],
        foodAllergies =
            (json['foodAllergies'] as List).map((e) => e.toString()).toList(),
        vaccines = json['vaccines'] != null
            ? (json['vaccines'] as List)
                .map((e) => Vaccine.fromJson(e))
                .toList()
            : [];

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, dateOfBirth: $dateOfBirth, breed: $breed, weight: $weight, sex: $sex, vetName: $vetName, vetPhone: $vetPhone, ownerUsername: $ownerUsername, foodAllergies: $foodAllergies, vaccines: $vaccines}';
  }
}
