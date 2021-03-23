import 'dart:convert';
import 'package:area/component/storage.dart';
import 'package:area/service/FacebookSignup.dart';
import 'package:area/service/authService.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../service/GoogleSignup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SecureStorage secureStorage = SecureStorage();

  var username, password, response;
  bool dispError = false;
  var msg = '';
  var url, resp;

  @override
  void initState() {
    super.initState();
    // secureStorage.readSecureData('UserName').then((value) {
    //   print("username from mlogin");
    //   print(value);
    // });
  }

  Widget _buildInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: labelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            onChanged: (val) {
              username = val;
            },
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.blueGrey,
              ),
              hintText: 'Your Username',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
        Text(
          'Password',
          style: labelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            obscureText: true,
            onChanged: (val) {
              password = val;
            },
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.blueGrey,
              ),
              hintText: 'Your Password',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 150,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {
          AuthService().login(username, password).then((value) {
            response = json.decode(value.body);
            // print(response);
            if (response['status'] == true) {
              secureStorage.writeSecureData('UserId', response['data']['_id']);
              secureStorage.writeSecureData(
                  'UserEmail', response['data']['email']);
              response['data']['confirmed']
                  ? secureStorage.writeSecureData('Confirmed', "true")
                  : secureStorage.writeSecureData('Confirmed', "false");

              secureStorage.writeSecureData(
                  'UserName', response['data']['username']);
              secureStorage.writeSecureData(
                  'UserToken', response['data']['token']);
              Navigator.of(context).pushReplacementNamed('/Navigation',
                  arguments: {'confirmed': response['data']['confirmed']});
            } else {
              setState(() {
                dispError = true;
                msg = response['data'];
              });
            }
          })
        },
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.lightBlue,
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => FacebookAuth.getAuthLink().then((value) {
              // print(value.body);
              resp = json.decode(value.body);
              setState(() {
                url = resp['data']['url'];
              });
              if (resp['status'] == true) {
                Navigator.pushReplacementNamed(context, '/OpenWebview',
                    arguments: {'url': url, 'service': "Facebook"});
              }
            }),
            AssetImage(
              'assets/facebook.png',
            ),
          ),
          _buildSocialBtn(
            () => GoogleAuth.getAuthLink().then((value) {
              // print(value.body);
              resp = json.decode(value.body);
              setState(() {
                url = resp['data']['url'];
              });
              if (resp['status'] == true) {
                Navigator.pushReplacementNamed(context, '/OpenWebview',
                    arguments: {'url': url, 'service': "Google"});
              }
            }),
            AssetImage(
              'assets/google1.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => {Navigator.pushReplacementNamed(context, '/NewAccount')},
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildInput(),
                      dispError ? Text(msg, style: errorStyle) : SizedBox(),
                      _buildLoginBtn(),
                      _buildSignInWithText(),
                      _buildSocialBtnRow(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
