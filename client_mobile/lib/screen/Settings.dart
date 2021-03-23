import 'package:flutter/material.dart';

import '../constants.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var password;
  var newPassword;

  Widget _buildInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const ListTile(
          title: Center(
              child: Text('Change your password',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: 20))),
        ),
        SizedBox(height: 10.0),
        Text(
          'Password',
          style: labelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          width: 270.0,
          child: TextField(
            onChanged: (val) {
              password = val;
            },
            obscureText: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              hintText: 'Old Password',
              hintStyle: hintTextStyle,
              contentPadding: EdgeInsets.only(top: 14.0),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'New Password',
          style: labelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          width: 270.0,
          child: TextField(
            obscureText: true,
            onChanged: (val) {
              newPassword = val;
            },
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              hintText: 'New Password',
              hintStyle: hintTextStyle,
              contentPadding: EdgeInsets.only(top: 14.0),
            ),
          ),
        ),
        ElevatedButton(onPressed: () {}, child: Text("Confirm"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue[800],
        title: Text("Settings"),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              width: 350,
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: _buildInput())),
        ],
      )),
    );
  }
}
