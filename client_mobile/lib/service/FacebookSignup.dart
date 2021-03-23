import 'dart:convert';
import 'package:area/component/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FacebookAuth {
  final SecureStorage secureStorage = SecureStorage();

  static Future<http.Response> getAuthLink() async {
    final response = await http.get(env['HOST'] + '/getFacebookAuthURL');

    if (response.statusCode == 200) {
      // print(response.body);
      return response;
    } else {
      throw Exception('Failed to get url');
    }
  }

  Future<http.Response> facebookLogin(String token) async {
    return await http.post(
      env['HOST'] + '/signWithFacebook',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'access_token': token}),
    );
  }

  void facebookOauth(var uri, context) async {
    var token, resp;
    if (uri.query.contains('access_token')) {
      token = uri.queryParameters['access_token'];
      if (token != null) {
        FacebookAuth().facebookLogin(token).then((value) {
          resp = json.decode(value.body);
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
