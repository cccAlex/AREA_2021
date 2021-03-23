import 'package:area/screen/ConfirmEmail.dart';
import 'package:flutter/material.dart';
import 'package:area/screen/Workflow.dart';
import 'package:area/screen/Home.dart';
import 'package:area/screen/Profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar(this.arguments);
  final Map arguments;
  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  var _currentIndex = 1;
  final tabs = [
    Center(child: Workflow()),
    Center(child: Home()),
    Center(child: Profile()),
  ];

  @override
  void initState() {
    super.initState();

    if (widget.arguments != null) {
      if (widget.arguments["index"] != null)
        setState(() {
          _currentIndex = widget.arguments["index"];
        });
      if (widget.arguments["confirmed"] != null &&
          !widget.arguments["confirmed"]) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showDialog<String>(
              context: context,
              builder: (BuildContext context) => ConfirmEmail());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              title: Text('Workflow'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Setting'),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
