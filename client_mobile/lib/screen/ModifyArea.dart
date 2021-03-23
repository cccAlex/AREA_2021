import 'dart:convert';

import 'package:area/component/ServiceLogo.dart';
import 'package:area/component/storage.dart';
import 'package:area/service/Area.dart';
import 'package:area/service/AuthManager.dart';
import 'package:flutter/material.dart';

class ModifyArea extends StatefulWidget {
  const ModifyArea(this.arguments);
  final Map arguments;
  @override
  _ModifyAreaState createState() => _ModifyAreaState();
}

class _ModifyAreaState extends State<ModifyArea> {
  bool active = true;

  String areaID;

  ///Value of service 1 dropdownlist
  String dropdownValue1;
  Map<String, dynamic> service1Param = {"params": {}};

  ///Value of service 2 dropdownlist
  String dropdownValue2;
  Map<String, dynamic> service2Param = {"params": {}};

  ///Value of action dropdownlist
  String actionValue;

  ///Value of reaction dropdownlist
  String reactionValue;

  ///Webhook
  String webhook1;

  ///Webhook
  String webhook2;

  var refreshTime;
  //displayed timer
  String timer;
  var jsonData;
  final SecureStorage secureStorage = SecureStorage();
  var service1Response;
  var service2Response;
  // var url, resp;
  var allData;

  ///Function to load service json
  Future<String> printDailyNewsDigest() async {
    String jsonArray =
        await DefaultAssetBundle.of(context).loadString("assets/services.json");
    return jsonArray;
  }

  ///Get all user data and read jeson file during the init of the widget
  @override
  void initState() {
    super.initState();
    secureStorage.readAlldata().then((value) {
      setState(() {
        allData = value;
      });
      Area().getRefreshTime(allData["UserToken"]).then((value) {
        setState(() {
          refreshTime = json.decode(value.body);
        });
      });
      setState(() {
        dropdownValue1 = widget.arguments["service1"];
        dropdownValue2 = widget.arguments["service2"];
        actionValue = widget.arguments["action"]["name"];
        reactionValue = widget.arguments["reaction"]["name"];
        // print(widget.arguments["reaction"]["serviceParams"]["webhookURL"]);
        widget.arguments["active"] == "true" ? active = true : active = false;
        areaID = widget.arguments["areaID"];
        if (widget.arguments["action"]["serviceParams"] != null &&
            widget.arguments["action"]["serviceParams"]["webhookURL"] != null)
          webhook1 = widget.arguments["action"]["serviceParams"]["webhookURL"];
        if (widget.arguments["reaction"]["serviceParams"] != null &&
            widget.arguments["reaction"]["serviceParams"]["webhookURL"] != null)
          webhook2 =
              widget.arguments["reaction"]["serviceParams"]["webhookURL"];
        // print("webhook2, = $webhook2");
      });
      checkService(allData["UserToken"], dropdownValue1, 1);
      checkService(allData["UserToken"], dropdownValue2, 2);
    });
    printDailyNewsDigest().then((value) {
      setState(() {
        jsonData = JsonDecoder().convert(value);
      });
    });
  }

  void checkService(token, service, serviceNb) {
    print(serviceNb);
    Area().getService(allData["UserToken"], service).then((value) {
      print(value.body);
      setState(() {
        if (serviceNb == 1)
          service1Response = json.decode(value.body);
        else
          service2Response = json.decode(value.body);
      });
      // if (service1Response["data"] != null || service2Response["data"] != null)
      setState(() {
        if (serviceNb == 1 && service1Response["data"] != null)
          service1Param = service1Response["data"]["params"];
        else if (serviceNb == 2 && service2Response["data"] != null)
          service2Param = service2Response["data"]["params"];
      });
    });
  }

  ///First service dropdownlist
  Widget _service1DropDownList() {
    if (jsonData != null) {
      return DropdownButton(
        hint: Text("Service"),
        value: dropdownValue1,
        underline: Container(),
        icon: Icon(Icons.arrow_downward),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue1 = newValue;
            actionValue = null;
          });
          checkService(allData["UserToken"], newValue, 1);
        },
        items: jsonData["service"]
            .keys
            .toList()
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  ///Second service dropdownlist
  Widget _service2DropDownList() {
    if (jsonData != null) {
      return DropdownButton(
        hint: Text("Service"),
        value: dropdownValue2,
        underline: Container(),
        icon: Icon(Icons.arrow_downward),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue2 = newValue;
            reactionValue = null;
          });
          checkService(allData["UserToken"], newValue, 2);
        },
        items: jsonData["service"]
            .keys
            .toList()
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  ///Action dropdownlist
  Widget _subDropDownList1(String service) {
    if (service == null) service = "Youtube";
    if (jsonData != null) {
      return DropdownButton<String>(
        hint: Text('action'),
        value: actionValue,
        icon: Icon(Icons.arrow_downward),
        underline: Container(),
        onChanged: (String newValue) {
          setState(() {
            actionValue = newValue;
          });
        },
        items: jsonData['service'][service]['action']
            .keys
            .toList()
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  ///Reaction dropdownlist
  Widget _subDropDownList2(String service) {
    if (service == null) service = "Youtube";
    if (jsonData != null) {
      return DropdownButton(
        hint: Text("reaction"),
        value: reactionValue,
        underline: Container(),
        icon: Icon(Icons.arrow_downward),
        onChanged: (String newValue) {
          setState(() {
            reactionValue = newValue;
          });
        },
        items: jsonData["service"][service]['reaction']
            .keys
            .toList()
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  ///Widget to put 2 services together
  Widget buildDropDown() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _service1DropDownList(),
              _service2DropDownList(),
            ]));
  }

  ///Widget to put action/reaction list together
  Widget buildSubDropDown() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _subDropDownList1(dropdownValue1),
              _subDropDownList2(dropdownValue2),
            ]));
  }

  ///Widget that generate the service logo and connexion button
  Widget serviceLogin(AssetImage image, String service, resp, nb) {
    return Container(
        child: Column(
      children: <Widget>[
        ServiceLogo(image, 80.0),
        if (resp != null)
          if (service != "Default" && service != "Discord")
            resp["data"] == null
                ? ElevatedButton(
                    onPressed: () => AuthManager()
                            .auth(service, allData["UserToken"])
                            .then((value) {
                          print(value.body);
                          var resp, url;
                          resp = json.decode(value.body);
                          url = resp['data']['url'];
                          if (resp['status'] == true) {
                            Navigator.pushReplacementNamed(
                                context, '/OpenWebview', arguments: {
                              'url': url,
                              'service': service,
                              'token': allData['UserToken']
                            });
                          }
                        }),
                    child: Text("connect"))
                : ElevatedButton(
                    onPressed: () {
                      Area()
                          .removeService(allData['UserToken'], service)
                          .then((value) {
                        print(value.body);
                        checkService(allData["UserToken"], service, nb);
                      });
                    },
                    child: Text("disconnect"))
      ],
    ));
  }

  ///Select the service logo
  Widget chooseLogo(String service, resp, nb) {
    switch (service) {
      case "Discord":
        return (serviceLogin(
            AssetImage(
              'assets/discord.webp',
            ),
            "Discord",
            resp,
            nb));
        break;
      case "Spotify":
        return (serviceLogin(
            AssetImage(
              'assets/spotify2.png',
            ),
            "Spotify",
            resp,
            nb));
        break;
      case "Youtube":
        return (serviceLogin(
            AssetImage(
              'assets/youtube.png',
            ),
            "Youtube",
            resp,
            nb));
        break;
      case "Google Gmail":
        return (serviceLogin(
            AssetImage(
              'assets/gmail_logo.png',
            ),
            "Google Gmail",
            resp,
            nb));
        break;
      case "Google Calendar":
        return (serviceLogin(
            AssetImage(
              'assets/google_calendar_logo.png',
            ),
            "Google Calendar",
            resp,
            nb));
        break;
      case "Google Drive":
        return (serviceLogin(
            AssetImage(
              'assets/google_drive_logo.png',
            ),
            "Google Drive",
            resp,
            nb));
        break;
      case "Weather":
        return (serviceLogin(
            AssetImage(
              'assets/weather.png',
            ),
            "Weather",
            resp,
            nb));
        break;
      case "Area Mailer":
        return (serviceLogin(
            AssetImage(
              'assets/email.png',
            ),
            "Area Mailer",
            resp,
            nb));
        break;
      default:
        return (serviceLogin(
            AssetImage(
              'assets/add.png',
            ),
            "Default",
            resp,
            nb));
        break;
    }
  }

  ///Widget to put 2 logo together
  Widget buildLogoRow() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Column(children: <Widget>[
                chooseLogo(dropdownValue1, service1Response, 1),
                if (dropdownValue1 == "Discord")
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 60.0,
                    width: 120,
                    child: TextFormField(
                      initialValue: webhook1,
                      onChanged: (val) {
                        webhook1 = val;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 14.0),
                        hintText: 'Webhook',
                      ),
                    ),
                  ),
              ])),
              Container(
                  child: Column(children: <Widget>[
                chooseLogo(dropdownValue2, service2Response, 2),
                if (dropdownValue2 == "Discord")
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 60.0,
                    width: 120,
                    child: TextFormField(
                      initialValue: webhook2,
                      onChanged: (val) {
                        webhook2 = val;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 14.0),
                        hintText: 'Webhook',
                      ),
                    ),
                  )
              ])),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.lightBlue[800],
          title: Text("Edit"),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Modify your area',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        )),
                    // subtitle: Text(''),
                  ),
                  buildDropDown(),
                  buildLogoRow(),
                  buildSubDropDown(),
                  if (active == false)
                    IconButton(
                        icon: Icon(Icons.play_arrow),
                        color: Colors.grey,
                        highlightColor: Colors.blueAccent,
                        splashColor: Colors.lightBlueAccent,
                        iconSize: 48,
                        onPressed: () {
                          Area()
                              .runArea(allData["UserToken"], areaID)
                              .then((value) {
                            setState(() {
                              active = true;
                            });
                          });
                        })
                  else
                    IconButton(
                        icon: Icon(Icons.pause),
                        color: Colors.grey,
                        highlightColor: Colors.blueAccent,
                        splashColor: Colors.lightBlueAccent,
                        iconSize: 48,
                        onPressed: () {
                          Area()
                              .stopArea(allData["UserToken"], areaID)
                              .then((value) {
                            setState(() {
                              active = false;
                            });
                          });
                        }),
                  IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      color: Colors.grey,
                      highlightColor: Colors.blueAccent,
                      splashColor: Colors.lightBlueAccent,
                      iconSize: 48,
                      onPressed: () {
                        if (dropdownValue1 != null &&
                            dropdownValue2 != null &&
                            actionValue != null &&
                            reactionValue != null) print("Modify");
                      }),
                ],
              )),
        )));
  }
}
