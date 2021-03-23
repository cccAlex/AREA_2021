import 'dart:convert';
import 'package:area/component/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SpotifyAuth {
  final SecureStorage secureStorage = SecureStorage();

  static Future<http.Response> getAuthLink(token) async {
    final response = await http.get(
      env['HOST'] + '/getSpotifyAuthURL',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      // print(response.body);
      return response;
    } else {
      throw Exception('Failed to get url');
    }
  }

  Future<http.Response> spotifyLogin(String state, String code, token) async {
    return await http.post(
      env['HOST'] + '/spotifySignIn',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{'state': state, 'code': code}),
    );
  }

  void spotifyOauth(var uri, context, token) async {
    var code, state, resp;
    if (uri.query.contains('code')) {
      state =
          (uri.query.contains('state')) ? uri.query.contains('state') : "null";
      code = uri.queryParameters['code'];
      if (code != null) {
        SpotifyAuth().spotifyLogin(state, code, token).then((value) {
          resp = json.decode(value.body);
          print(resp);
          // secureStorage.writeSecureData('Spotify', "ok");
          Navigator.of(context).pushReplacementNamed('/Navigation');
        });
      }
    }
  }
}
