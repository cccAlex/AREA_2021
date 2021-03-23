import 'dart:convert';
import 'package:area/component/storage.dart';
import 'package:area/component/utils.dart';
import 'package:area/service/Area.dart';
import 'package:flutter/material.dart';

class Workflow extends StatefulWidget {
  @override
  _WorkflowState createState() => _WorkflowState();
}

class _WorkflowState extends State<Workflow> {
  final SecureStorage secureStorage = SecureStorage();
  var allData;
  var allArea;

  @override
  void initState() {
    super.initState();
    secureStorage.readAlldata().then((value) {
      setState(() {
        allData = value;
      });
      Area().getAreaList(allData["UserToken"]).then((value) {
        print(value.body);
        setState(() {
          allArea = json.decode(value.body);
        });
      });
    });
  }

  Widget _buildAreaCard(BuildContext context, int index) {
    print(allArea["data"][0]["_id"]);
    return new Container(
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  chooseServiceLogo(
                      allArea["data"][index]["action"]["serviceName"]),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                    size: 35,
                  ),
                  chooseServiceLogo(
                      allArea["data"][index]["reaction"]["serviceName"]),
                ])),
            Flexible(
              child: Text(allArea["data"][index]["action"]["name"] +
                  ' + ' +
                  allArea["data"][index]["reaction"]["name"]),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close_rounded),
                    color: Colors.red,
                    onPressed: () {
                      Area()
                          .removeArea(allData["UserToken"],
                              allArea["data"][index]["_id"])
                          .then((value) {
                        print(value.body);
                        Area().getAreaList(allData["UserToken"]).then((value) {
                          setState(() {
                            allArea = json.decode(value.body);
                          });
                        });
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.mode_edit),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/ModifyArea', arguments: {
                        'service1': allArea["data"][index]["action"]
                            ["serviceName"],
                        'service2': allArea["data"][index]["reaction"]
                            ["serviceName"],
                        'action': allArea["data"][index]["action"],
                        'reaction': allArea["data"][index]["reaction"],
                        'areaID': allArea["data"][index]["_id"],
                        'active': allArea["data"][index]["active"],
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 1;
    if (allArea != null) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.lightBlue[800],
            title: Text("AREA"),
          ),
          body: Container(
              width: screenWidth,
              child: new ListView.builder(
                  itemCount: allArea["data"].length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildAreaCard(context, index))));
    }
    return Container();
  }
}
