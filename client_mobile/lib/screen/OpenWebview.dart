import 'package:area/service/FacebookSignup.dart';
import 'package:area/service/GoogleCalendar.dart';
import 'package:area/service/GoogleDrive.dart';
import 'package:area/service/GoogleGmail.dart';
import 'package:area/service/GoogleSignup.dart';
import 'package:area/service/SpotifySignup.dart';
import 'package:area/service/Youtube.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class OpenWebview extends StatefulWidget {
  const OpenWebview(this.arguments);
  final Map arguments;
  @override
  _OpenWebviewState createState() => _OpenWebviewState();
}

class _OpenWebviewState extends State<OpenWebview> {
  final webview = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    webview.onStateChanged.listen((event) {
      if (widget.arguments["service"] == "Google") {
        var uri = Uri.parse(event.url);
        GoogleAuth().googleOauth(uri, context);
      } else if (widget.arguments["service"] == "Facebook") {
        var uri = Uri.parse(event.url.replaceFirst('#', ''));
        FacebookAuth().facebookOauth(uri, context);
      } else if (widget.arguments["service"] == "Spotify") {
        var uri = Uri.parse(event.url);
        SpotifyAuth().spotifyOauth(uri, context, widget.arguments['token']);
      } else if (widget.arguments["service"] == "Youtube") {
        var uri = Uri.parse(event.url);
        Youtube().youtubeOauth(uri, context, widget.arguments['token']);
      } else if (widget.arguments["service"] == "Google Gmail") {
        var uri = Uri.parse(event.url);
        GoogleGmail().gmailOauth(uri, context, widget.arguments['token']);
      } else if (widget.arguments["service"] == "Google Calendar") {
        var uri = Uri.parse(event.url);
        GoogleCalendar().calendarOauth(uri, context, widget.arguments['token']);
      } else if (widget.arguments["service"] == "Google Drive") {
        var uri = Uri.parse(event.url);
        GoogleDrive().driveOauth(uri, context, widget.arguments['token']);
      }
    });
  }

  @override
  void dispose() {
    webview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.arguments);
    return WebviewScaffold(
      userAgent: "random",
      url: widget.arguments["url"],
    );
  }
}
