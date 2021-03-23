import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  Future<http.Response> login(String username, String password) async {
    return await http.post(
      env['HOST'] + '/signIn',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );
  }

  Future<http.Response> signUp(
      String mail, String username, String password) async {
    return await http.post(
      env['HOST'] + '/signUp',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': mail,
        'username': username,
        'password': password
      }),
    );
  }

  Future<http.Response> sendConfirmation(userId, token) async {
    return await http.post(
      env['HOST'] + '/resendConfirmationEmail',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        '_id': userId,
      }),
    );
  }
}
