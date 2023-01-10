import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../dogs/models/dog.dart';
import '../profile/models/challenge.dart';
import '../profile/models/user.dart';

class Services {
  static String savedUsername = '';
  static String picture = "";
  static String host = 'http://192.168.0.102:8080';
  // static String host ='http://192.168.43.247:8080';
  // static String host = 'http://localhost:8080';

  static Future<User?> login(
      {String? email, required String password, String? username}) async {
    Uri url = Uri.parse("$host/login");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json"
    };

    if (email != null) {
      final account = jsonEncode({"email": email, "password": password});
      var response = await http.post(url, headers: headers, body: account);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (decodedResponse["picture"] == null) {
        picture = "";
      } else {
        picture = decodedResponse["picture"];
      }
      return User.fromJson(decodedResponse as Map<String, dynamic>);
    } else {
      if (username != null) {
        final account =
            jsonEncode({"username": username, "password": password});
        var response = await http.post(url, headers: headers, body: account);
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        savedUsername = username;
        if (decodedResponse["picture"] == null) {
          picture = "";
        } else {
          picture = decodedResponse["picture"];
        }
        return User.fromJson(decodedResponse as Map<String, dynamic>);
      }
    }
    return null;
  }

  static Future<Map<dynamic, dynamic>> register(String firstName,
      String lastName, String email, String password, File? image) async {
    Uri url = Uri.parse("$host/register");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json"
    };

    final account = jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password
    });

    if (image != null) {
      var response = await http.post(url, headers: headers, body: account);
      try {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        String username = decodedResponse['username'];
        updateProfilePic(username, image);
        return decodedResponse;
      } catch (e) {
        return {"error": response.body};
      }
    }
    var response = await http.post(url, headers: headers, body: account);
    try {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      return decodedResponse;
    } catch (e) {
      return {"error": response.body};
    }
  }

  static void updateProfilePic(String username, File image) async {
    Uri url = Uri.parse("$host/upload");


    var stream = http.ByteStream(image.openRead());
    var length = await image.length();

    var request = http.MultipartRequest('POST', url);
    final httpImage =
        http.MultipartFile('picture', stream, length, filename: 'test.jpg');
    request.fields["username"] = username;
    request.files.add(httpImage);
    request.send();
  }


  static Future<Uint8List> getPicture() async {
    Uri url = Uri.parse("$host/getProfilePicture/${Services.savedUsername}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json"
    };
    var response = await http.get(url, headers: headers);
    var decodedResponse =
        jsonDecode(utf8.decode(response.body.codeUnits)) as Future<Uint8List>;
    return decodedResponse;
  }

  static checkImg({String? userPic}) {
    if(userPic!=null&&userPic!="") {
      return Image
          .memory(base64.decode(userPic))
          .image;
    }
    else {
      if (picture != "") {
        return Image
            .memory(base64.decode(Services.picture))
            .image;
      } else {
        return const AssetImage("assets/defaultProf.jpg");
      }
    }
  }

  static Future<List<String>> getVaccineTypes() async {
    try {
      Uri url = Uri.parse("$host/vaccineTypes");


      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      };

      var response = await http.get(url, headers: headers);
      Iterable l = json.decode(response.body);
      List<String> vaccines =
          List<String>.from(l.map((model) => model.toString()));
      return vaccines;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<String>> getAllergies() async {
    try {
      Uri url = Uri.parse("$host/allergies");


      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      };

      var response = await http.get(url, headers: headers);
      Iterable l = json.decode(response.body);
      List<String> allergies =
          List<String>.from(l.map((model) => model.values.first));
      return allergies;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<String?> saveDog(Dog dog) async {
    try {
      Uri url = Uri.parse("$host/dog");


      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      };

      final dogJson = jsonEncode(dog.toJson());
      var response = await http.post(url, headers: headers, body: dogJson);
      return response.body;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> deleteDog(String dogId) async {
    try {
      Uri url = Uri.parse("$host/dog?id=$dogId");


      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      };

      var response = await http.delete(url, headers: headers);
      return response.body;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> editDog(Dog dog) async {
    try {
      Uri url = Uri.parse("$host/dog");


      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      };

      final dogJson = jsonEncode(dog.toJson());

      var response = await http.put(url, headers: headers, body: dogJson);
      return response.body;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Dog>> getDogs(String username) async {
    Uri url = Uri.parse("$host/dogs");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
    };

    var response = await http.get(url, headers: headers);
    Iterable l = json.decode(response.body);
    List<Dog> dogs = List<Dog>.from(l.map((model) => Dog.fromJson(model)));
    return dogs;
  }

  static Future<bool> updateSteps(User user) async {
    try {
      Uri url = Uri.parse("$host/stepCount");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json"
      };

      final userEncoded = jsonEncode({
        "email": user.email,
        "username": user.username,
        "stepCount": user.stepCount,
        "token": user.token
      });

      var response = await http.put(url, headers: headers, body: userEncoded);
      print(response.body);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<String> resetPassword(
      String username, String oldPass, String newPass, String? email) async {
    try {
      String url =
          "$host/resetPassword?username=$username&oldPassword=$oldPass&newPassword=$newPass";
      if(username.isEmpty&&email!=null){
       User? user = await getUser('', email);
       username = user?.username??'';
      }

      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json"
      };

      var response = await http.post(uri, headers: headers);
      return response.body;
    } catch (e) {
      print(e);
      return "Something went wrong.";
    }
  }

  static Future<int?> getCurrentLevel(String username) async {
    try {
      String url = "$host/currentLevel?username=$username";

      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      };

      var response = await http.get(uri, headers: headers);

      return int.tryParse(response.body);
    } catch (e) {
      print(e);
      return -1;
    }
  }

  static Future<List<Challenge>> getChallenges(int level) async {
    try {
      String url = "$host/challenges?levelNr=$level";

      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      };

      var response = await http.get(uri, headers: headers);
      Iterable l = json.decode(response.body);
      List<Challenge> challenges =
          List<Challenge>.from(l.map((model) => Challenge.fromJson(model)));
      return challenges;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<User?> getUser(String username, String email) async {
    try {
      String url = "$host/users";

      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      };

      Response response = await http.get(uri, headers: headers);
      Iterable l = json.decode(response.body);

      List<User> users =
          List<User>.from(l.map((model) => User.fromJson(model)));
      final user = users.firstWhere(
          (element) => element.username == username || element.email == email);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> updatePoints(String username, int points) async {
    try {
      Uri url = Uri.parse("$host/userPoints?username=$username&points=$points");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json"
      };


      var response = await http.put(url, headers: headers);
      print(response.body);
      return response.body == 'Update was successfull';
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<String?> forgotPassword(String email) async {
    try {
      Uri url = Uri.parse("$host/forgotPassword?email=$email");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        "Accept": "application/json"
      };

      var response = await http.post(url, headers: headers);
      return response.body;
    } catch (e) {
      print(e);
      return null;
    }
  }

}
