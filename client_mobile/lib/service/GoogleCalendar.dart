import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleCalendar {
  static Future<http.Response> getAuthLink(token) async {
    final response = await http.get(
      env['HOST'] + '/getGoogleCalendarAuthURL',
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

  static Future<http.Response> calendarLogin(
      String state, String code, token) async {
    return await http.post(
      env['HOST'] + '/googleCalendarSignIn',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{'state': state, 'code': code}),
    );
  }

  void calendarOauth(var uri, context, token) async {
    // print("u call me ?");
    var code, state, resp;
    if (uri.query.contains('code')) {
      state =
          (uri.query.contains('state')) ? uri.query.contains('state') : "null";
      code = uri.queryParameters['code'];
      if (code != null) {
        await GoogleCalendar.calendarLogin(state, code, token);
        Navigator.of(context).pushReplacementNamed('/Navigation');
      }
    }
  }
}
