import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Area {
  Future<http.Response> runArea(token, areaID) async {
    return await http.post(
      env['HOST'] + '/runArea',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'areaID': areaID}),
    );
  }

  Future<http.Response> stopArea(token, areaID) async {
    return await http.post(
      env['HOST'] + '/stopArea',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'areaID': areaID}),
    );
  }

  Future<http.Response> getRefreshTime(token) async {
    final response = await http.get(
      env['HOST'] + '/getRefreshTime',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    // if (response.statusCode == 200) {
    // print(response.body);
    return response;
    // } else {
    //   throw Exception('Failed to get url');
    // }
  }

  Future<http.Response> addArea(token, area) async {
    return await http.post(
      env['HOST'] + '/addArea',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(area),
    );
  }

  Future<http.Response> getService(token, name) async {
    Map<String, String> queryParameters = {
      'name': name,
    };
    var uri = Uri.http(env['LOCALHOST'], 'api/service', queryParameters);
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> removeService(token, serviceName) async {
    return await http.post(
      env['HOST'] + '/removeService',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'name': serviceName,
      }),
    );
  }

  Future<http.Response> getServiceList(token) async {
    var uri = Uri.http(env['LOCALHOST'], 'api/services');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> getAreaList(token) async {
    var uri = Uri.http(env['LOCALHOST'], 'api/area');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> removeArea(token, areaId) async {
    return await http.post(
      env['HOST'] + '/removeArea',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'areaID': areaId,
      }),
    );
  }
}
