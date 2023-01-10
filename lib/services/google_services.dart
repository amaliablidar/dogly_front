import 'dart:convert';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleServices {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'https://www.googleapis.com/auth/cloud-platform',
      'https://www.googleapis.com/auth/cloud-vision',
    ],
    clientId:
        '682054204562-e5utaa7ubq782ho3in5v72704lqvdg1n.apps.googleusercontent.com',
  );

  Future<String?> getAccessToken() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    return googleAuth?.accessToken;
  }

  Future<Map<String, dynamic>> detectObjects(File image) async {
    String? accessToken = await getAccessToken();
    const String apiUrl = 'https://vision.googleapis.com/v1/images:annotate';
    final url = Uri.parse(apiUrl);
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> payload = {
      'requests': [
        {
          'image': {
            'content': base64Encode(image.readAsBytesSync()),
          },
          'features': [
            {
              'type': 'LABEL_DETECTION',
            },
          ],
        },
      ],
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
