import 'package:area/service/GoogleCalendar.dart';
import 'package:area/service/GoogleDrive.dart';
import 'package:area/service/GoogleGmail.dart';
import 'package:area/service/SpotifySignup.dart';
import 'package:area/service/Youtube.dart';
import 'package:http/http.dart' as http;

class AuthManager {
  Future<http.Response> auth(service, token) {
    switch (service) {
      case "Spotify":
        return SpotifyAuth.getAuthLink(token);
        break;
      case "Discord":
        break;
      case "Youtube":
        return Youtube.getAuthLink(token);
        break;
      case "Google Gmail":
        return GoogleGmail.getAuthLink(token);
        break;
      case "Google Calendar":
        return GoogleCalendar.getAuthLink(token);
        break;
      case "Google Drive":
        return GoogleDrive.getAuthLink(token);
        break;
      case "Weather":
        break;
      default:
    }
  }
}
