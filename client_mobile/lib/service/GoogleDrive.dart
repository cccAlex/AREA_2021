// router.get('/getGoogleDriveAuthURL', checkToken, googleDrive.getGoogleDriveAuthURL);
// router.post('/googleDriveSignIn', checkToken, googleDrive.googleDriveSignIn);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleDrive {
  static Future<http.Response> getAuthLink(token) async {
    final response = await http.get(
      env['HOST'] + '/getGoogleDriveAuthURL',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to get url');
    }
  }

  static Future<http.Response> driveLogin(
      String state, String code, token) async {
    return await http.post(
      env['HOST'] + '/googleDriveSignIn',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{'state': state, 'code': code}),
    );
  }

  void driveOauth(var uri, context, token) async {
    var code, state, resp;
    if (uri.query.contains('code')) {
      state =
          (uri.query.contains('state')) ? uri.query.contains('state') : "null";
      code = uri.queryParameters['code'];
      if (code != null) {
        await GoogleDrive.driveLogin(state, code, token);
        Navigator.of(context).pushReplacementNamed('/Navigation');
      }
    }
  }
}
