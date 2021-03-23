import 'package:area/component/ServiceLogo.dart';
import 'package:flutter/material.dart';

Widget chooseServiceLogo(String service) {
  switch (service) {
    case "Discord":
      return (ServiceLogo(AssetImage('assets/discord.webp'), 50.0));
      break;
    case "Spotify":
      return (ServiceLogo(AssetImage('assets/spotify2.png'), 50.0));
      break;
    case "Youtube":
      return (ServiceLogo(
          AssetImage(
            'assets/youtube.png',
          ),
          50.0));
      break;
    case "Google Gmail":
      return (ServiceLogo(
          AssetImage(
            'assets/gmail_logo.png',
          ),
          50.0));
      break;
    case "Google Drive":
      return (ServiceLogo(
          AssetImage(
            'assets/google_drive_logo.png',
          ),
          50.0));
      break;
    case "Google Calendar":
      return (ServiceLogo(
          AssetImage(
            'assets/google_calendar_logo.png',
          ),
          50.0));
      break;
    case "Weather":
      return (ServiceLogo(
          AssetImage(
            'assets/weather.png',
          ),
          50.0));
      break;
    case "Area Mailer":
      return (ServiceLogo(
          AssetImage(
            'assets/email.png',
          ),
          50.0));
      break;
    default:
      return (ServiceLogo(
          AssetImage(
            'assets/add.png',
          ),
          50.0));
      break;
  }
}
