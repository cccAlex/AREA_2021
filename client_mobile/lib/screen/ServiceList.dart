import 'dart:convert';
import 'dart:developer';

import 'package:area/component/storage.dart';
import 'package:area/component/utils.dart';
import 'package:area/service/Area.dart';
import 'package:flutter/material.dart';

class ServiceList extends StatefulWidget {
  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  //Todo a changer
  final String usename = "Clement";
  final SecureStorage secureStorage = SecureStorage();
  var allData;
  var allServices;

  @override
  void initState() {
    super.initState();
    secureStorage.readAlldata().then((value) {
      setState(() {
        allData = value;
      });
      Area().getServiceList(allData["UserToken"]).then((value) {
        print(value.body);
        setState(() {
          allServices = json.decode(value.body);
        });
      });
    });
  }

  Widget _buildServiceCard(BuildContext context, int index) {
    // print(allServices["data"][index]["name"]);
    return new Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            allServices["data"][index]["name"],
            style: TextStyle(color: Colors.blue[800], fontSize: 20),
          ),
        ),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              chooseServiceLogo(allServices["data"][index]["name"]),
              Text('Conneted as $usename'),
              if (allData != null)
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Area()
                        .removeService(allData["UserToken"],
                            allServices["data"][index]["name"])
                        .then((value) {
                      print(value.body);
                      Area().getServiceList(allData["UserToken"]).then((value) {
                        setState(() {
                          allServices = json.decode(value.body);
                        });
                      });
                    });
                  },
                  child: Text(
                    "Disconnect",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (allServices != null)
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.lightBlue[800],
            title: Text("Services"),
          ),
          body: Container(
            child: new ListView.builder(
                itemCount: allServices["data"].length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildServiceCard(context, index)),
          ));
    return Container();
  }
}
