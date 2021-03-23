import 'dart:convert';
import 'package:area/component/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleAuth {
  final SecureStorage secureStorage = SecureStorage();

  static Future<http.Response> getAuthLink() async {
    final response = await http.get(env['HOST'] + '/getGoogleAuthURL');

    if (response.statusCode == 200) {
      // print(response.body);
      return response;
    } else {
      throw Exception('Failed to get url');
    }
  }

  Future<http.Response> googleLogin(String state, String code) async {
    return await http.post(
      env['HOST'] + '/signWithGoogle',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'state': state, 'code': code}),
    );
  }

  void googleOauth(var uri, context) async {
    var code, state, resp;
    if (uri.query.contains('code')) {
      state =
          (uri.query.contains('state')) ? uri.query.contains('state') : "null";
      code = uri.queryParameters['code'];
      if (code != null) {
        GoogleAuth().googleLogin(state, code).then((value) {
          resp = json.decode(value.body);
          // print(resp['data']['_id']);
          secureStorage.writeSecureData('UserId', resp['data']['_id']);
          secureStorage.writeSecureData('UserEmail', resp['data']['email']);
          resp['data']['confirmed']
              ? secureStorage.writeSecureData('Confirmed', "true")
              : secureStorage.writeSecureData('Confirmed', "false");
          secureStorage.writeSecureData('UserName', resp['data']['username']);
          secureStorage.writeSecureData('UserToken', resp['data']['token']);
          Navigator.of(context).pushReplacementNamed('/Navigation',
              arguments: {'confirmed': resp['data']['confirmed']});
        });
      }
    }
  }
}
