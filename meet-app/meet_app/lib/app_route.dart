import 'package:flutter/material.dart';
import 'package:meet_app/pages/event/calendar_events_page.dart';
import 'package:meet_app/pages/event/event_list_page.dart';
import 'package:meet_app/pages/room/room_select_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRoute {
  static generateRoute(RouteSettings routeSettings) {
    if (routeSettings.name == '/') {
      return MaterialPageRoute(builder: (context) => EventListPage());
    }

    if (routeSettings.name == '/login') {
      return MaterialPageRoute(builder: (context) => const RoomSelectPage());
    }

    if (routeSettings.name == '/calendar') {
      return MaterialPageRoute(
          builder: (context) => const CalendarEventsPage());
    }

    return <String, WidgetBuilder>{};
  }

  static String getInitialRoute(SharedPreferences prefs) {
    final token = prefs.getString('selectedRoom');

    if (token == null || token == "") {
      return '/login';
    } else {
      return "/";
    }
  }
}
