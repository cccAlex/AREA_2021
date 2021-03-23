import 'dart:convert';

import 'package:area/component/storage.dart';
import 'package:area/service/authService.dart';
import 'package:flutter/material.dart';

class ConfirmEmail extends StatefulWidget {
  @override
  _ConfirmEmailState createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  final SecureStorage secureStorage = SecureStorage();
  Map<String, String> allData;

  @override
  void initState() {
    super.initState();
    secureStorage.readAlldata().then((value) {
      // print(value);
      setState(() {
        allData = value;
      });
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (allData != null) {
      return AlertDialog(
        title: Text("Verify your account"),
        content: Text("Please verify your account in the link sent to " +
            allData["UserEmail"]),
        actions: <Widget>[
          InkResponse(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("No")),
          FlatButton(
            child: Text("send email"),
            onPressed: () {
              showLoaderDialog(context);
              var result;
              AuthService()
                  .sendConfirmation(allData["UserId"], allData["UserToken"])
                  .then((value) {
                // print(value.body);
                result = json.decode(value.body);
                if (result["status"])
                  Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },
          ),
        ],
      );
    }
    return Container();
  }
}
