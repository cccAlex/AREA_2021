import 'package:area/screen/Home.dart';
import 'package:area/screen/ModifyArea.dart';
import 'package:area/screen/ServiceList.dart';
import 'package:area/screen/Settings.dart';
import 'package:area/screen/Workflow.dart';
import 'package:flutter/material.dart';
import 'package:area/screen/BottomNavBar.dart';
import 'package:area/screen/Login.dart';
import 'package:area/screen/NewAccount.dart';
import 'package:area/screen/OpenWebview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  await DotEnv.load();
  runApp(MaterialApp(
    title: 'AREA',
    initialRoute: '/',
    onGenerateRoute: (RouteSettings settings) {
      var routes = <String, WidgetBuilder>{
        '/': (context) => LoginScreen(),
        '/Navigation': (context) => BottomNavBar(settings.arguments),
        '/NewAccount': (context) => CreateUser(),
        '/OpenWebview': (context) => OpenWebview(settings.arguments),
        '/ServiceList': (context) => ServiceList(),
        '/Settings': (context) => Settings(),
        '/Home': (context) => Home(),
        '/ModifyArea': (context) => ModifyArea(settings.arguments),
        '/Workflow': (context) => Workflow(),
      };
      WidgetBuilder builder = routes[settings.name];
      return MaterialPageRoute(builder: (context) => builder(context));
    },
  ));
}
