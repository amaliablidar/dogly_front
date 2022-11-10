import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Services {
  static Future<Map<dynamic, dynamic>> login(
      {String? email, required String password, String? username}) async {
    ;
    Uri url = Uri.parse("http://localhost:8080/login");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json"
    };

    if (email != null) {
      final account = jsonEncode({"email": email, "password": password});
      var response = await http.post(url, headers: headers, body: account);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      return decodedResponse;
    } else {
      if (username != null) {
        final account =
            jsonEncode({"username": username, "password": password});
        var response = await http.post(url, headers: headers, body: account);
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        return decodedResponse;
      }
    }
    return {};
  }

  static Future<Map<dynamic, dynamic>> register(String firstName,
      String lastName, String email, String password, File? image) async {
    Uri url = Uri.parse("http://localhost:8080/register");

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
      ByteData bytes = await rootBundle.load(image.path);
      var response = await http.put(url,
          headers: headers, body: {"username": "amabl", "picture": bytes});
    }

    var response = await http.post(url, headers: headers, body: account);
    try {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      return decodedResponse;
    } catch (e) {
      return {"error": response.body};
    }
  }
}
