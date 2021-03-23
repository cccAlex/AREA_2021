import 'package:area/component/CurvPainter.dart';
import 'package:area/component/storage.dart';
import 'package:area/screen/ConfirmEmail.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final SecureStorage secureStorage = SecureStorage();
  var allData;

  @override
  void initState() {
    super.initState();
    secureStorage.readAlldata().then((value) {
      setState(() {
        allData = value;
      });
      // print(allData);
    });
  }

  Widget _buildButton() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ButtonTheme(
                  minWidth: 200.0,
                  height: 50.0,
                  child: FlatButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    // padding: EdgeInsets.symmetric(horizontal: 20.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pushNamed(context, '/ServiceList');
                    },
                    child: Text(
                      "Services",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                  minWidth: 200.0,
                  height: 50.0,
                  child: FlatButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    // padding: EdgeInsets.symmetric(horizontal: 20.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pushNamed(context, '/Settings');
                    },
                    child: Text(
                      "Settings",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                  minWidth: 200.0,
                  height: 50.0,
                  child: FlatButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    splashColor: Colors.redAccent,
                    onPressed: () {
                      secureStorage.deleteAllSecureData();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ))
            ]));
  }

  Widget _email() {
    return Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.email_outlined,
                color: Colors.black,
                size: 35,
              ),
              Text(
                allData["UserEmail"],
                style: mediumTextStyle,
              ),
              allData["Confirmed"] == "true"
                  ? Text("Verified", style: validateStyle)
                  : Text("Not verified", style: errorStyle),
              ElevatedButton(
                  onPressed: allData["Confirmed"] == "true"
                      ? null
                      : () {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    ConfirmEmail());
                          });
                        },
                  child: Text("send")),
            ]));
  }

  Widget _userInfo() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
                size: 65,
              ),
              Text(
                allData["UserName"],
                style: bigTextStyle,
              ),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    if (allData != null) {
      return Scaffold(
        body: MaterialApp(
          home: CustomPaint(
              painter: CurvePainter(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[_userInfo(), _email(), _buildButton()],
              )),
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
