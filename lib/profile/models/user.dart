import '../../dogs/models/dog.dart';

class User {
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  int? stepCount;
  String? token;
  List<Dog>? dogs;
  String? picture;

  User({
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.stepCount,
    this.token,
    this.dogs,
    this.picture,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['firstname'] = firstname;
    json['lastname'] = lastname;
    json['username'] = username;
    json['email'] = email;
    json['stepCount'] = stepCount;
    json['token'] = token;
    json['dogs'] = dogs;
    json['picture'] = picture;
    return json;
  }

  User.fromJson(Map<String, dynamic> json)
      : firstname = json["firstname"],
        lastname = json['lastname'],
        username = json['username'],
        email = json['email'],
        stepCount = json['stepCount'],
        token = json['token'],
        dogs = json['dogs'] != null
            ? (json['dogs'] as List).map((e) => Dog.fromJson(e)).toList()
            : [],
        picture =
            json["profilePic_id"] != null ? json["profilePic_id"]["data"] : "";

  @override
  String toString() {
    return 'User{firstname: $firstname, lastname: $lastname, profile: $picture, username: $username, email: $email, stepCount: $stepCount, token: $token, dogs: $dogs}';
  }
}
