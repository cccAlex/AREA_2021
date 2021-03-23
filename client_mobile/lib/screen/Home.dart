import 'dart:convert';

import 'package:area/component/ServiceLogo.dart';
import 'package:area/component/storage.dart';
import 'package:area/component/utils.dart';
import 'package:area/service/Area.dart';
import 'package:area/service/AuthManager.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  final _formKey = GlobalKey<FormState>();
  var service1Response;
  var service2Response;

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
      // print("username");
      setState(() {
        allData = value;
        Area().getRefreshTime(allData["UserToken"]).then((value) {
          // setState(() {
          refreshTime = json.decode(value.body);
          // });
        });
      });
    });
    printDailyNewsDigest().then((value) {
      setState(() {
        jsonData = JsonDecoder().convert(value);
      });
    });
  }

  void checkService(token, service, serviceNb) {
    Area().getService(allData["UserToken"], service).then((value) {
      // print(value.body);
      setState(() {
        if (serviceNb == 1)
          service1Response = json.decode(value.body);
        else
          service2Response = json.decode(value.body);
      });
      setState(() {
        if (serviceNb == 1) if (service1Response["data"] != null)
          service1Param = service1Response["data"]["params"];
        else
          service1Param = {};
        else if (serviceNb == 2) if (service2Response["data"] != null)
          service2Param = service2Response["data"]["params"];
        else
          service2Param = {};
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
      return Container(
          width: 200,
          padding: EdgeInsets.only(left: 10),
          child: DropdownButton<String>(
            hint: Text('action'),
            value: actionValue,
            isExpanded: true,
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
          ));
    } else {
      return CircularProgressIndicator();
    }
  }

  ///Reaction dropdownlist
  Widget _subDropDownList2(String service) {
    if (service == null) service = "Youtube";
    if (jsonData != null) {
      return Container(
          width: 200,
          child: DropdownButton(
            hint: Text("reaction"),
            value: reactionValue,
            isExpanded: true,
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
          ));
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
          if (service != "Default" &&
              service != "Discord" &&
              service != "Weather" &&
              service != "Area Mailer")
            resp["data"] == null
                ? ElevatedButton(
                    onPressed: () => AuthManager()
                            .auth(service, allData["UserToken"])
                            .then((value) {
                          // print(value.body);
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
                    child: TextField(
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
                    child: TextField(
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

  List buildInputs(
      List inputs, Map<String, TextEditingController> textEditingControllers) {
    var textFields = <TextField>[];
    inputs.forEach((str) {
      var textEditingController = new TextEditingController();
      textEditingControllers.putIfAbsent(str, () => textEditingController);
      return textFields.add(TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: str,
        ),
      ));
    });
    return textFields;
  }

  void fillParams(List params, String where, area, textEditingControllers) {
    params.forEach((str) {
      if (where == "action")
        area["action"]['params'][str] = textEditingControllers[str].text;
      else
        area["reaction"]['params'][str] = textEditingControllers[str].text;
    });
  }

  Map<String, dynamic> fillArea(
      textEditingControllers, textEditingControllers2) {
    Map<String, dynamic> area = {
      "refreshTime": timer,
      "action": {
        "name": actionValue,
        "params": {},
        "serviceName": dropdownValue1,
        "serviceParams": dropdownValue1 != "Discord"
            ? service1Param
            : {"webhookURL": webhook1},
      },
      "reaction": {
        "name": reactionValue,
        "params": reactionValue != "areaBotMailer"
            ? {}
            : {"email": allData["UserEmail"]},
        "serviceName": dropdownValue2,
        "serviceParams": dropdownValue2 != "Discord"
            ? service2Param
            : {"webhookURL": webhook2},
      }
    };
    fillParams(jsonData['service'][dropdownValue1]['action'][actionValue],
        "action", area, textEditingControllers);

    fillParams(jsonData['service'][dropdownValue2]['reaction'][reactionValue],
        "reaction", area, textEditingControllers2);
    return area;
  }

  ///Pop up to add additonnal information for the area
  void openForm(context) {
    Map<String, TextEditingController> textEditingControllers = {};
    var textFields = buildInputs(
        jsonData['service'][dropdownValue1]['action'][actionValue],
        textEditingControllers);

    Map<String, TextEditingController> textEditingControllers2 = {};
    var textFields2 = buildInputs(
        jsonData['service'][dropdownValue2]['reaction'][reactionValue],
        textEditingControllers2);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Configure your area',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          )),
                      Text(actionValue + ' + ' + reactionValue,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          )),
                      chooseServiceLogo(dropdownValue1),
                      Column(children: textFields),
                      chooseServiceLogo(dropdownValue2),
                      Column(children: textFields2),
                      StatefulBuilder(builder:
                          (BuildContext context, StateSetter dropDownState) {
                        return Center(
                          child: DropdownButton(
                            hint: Text("timer"),
                            value: timer,
                            underline: Container(),
                            icon: Icon(Icons.arrow_downward),
                            onChanged: (String newValue) {
                              dropDownState(() {
                                timer = newValue;
                              });
                            },
                            items: refreshTime["data"]
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value["value"],
                                child: Text(value["text"]),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Create"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                            }
                            Map<String, dynamic> area = fillArea(
                                textEditingControllers,
                                textEditingControllers2);
                            print(area);
                            Area()
                                .addArea(allData["UserToken"], area)
                                .then((value) {
                              Navigator.of(context).pop();
                              print(value.body);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          );
        });
  }

  ///Error popup
  void openError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("fill in all the fields please."),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.lightBlue[800],
          title: Text("AREA"),
        ),
        // body: DropDownList(),
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
                    title: Text('Create your area',
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
                            reactionValue != null)
                          openForm(context);
                        else {
                          openError();
                        }
                      }),
                ],
              )),
        )));
  }
}
