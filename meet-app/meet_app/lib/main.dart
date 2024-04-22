import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meet_app/app_route.dart';
import 'package:meet_app/pages/event/event_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  prefs = await SharedPreferences.getInstance();

  initializeDateFormatting().then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EventListPage(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => EventListPage(),
      },
      initialRoute: AppRoute.getInitialRoute(prefs!),
      onGenerateRoute: (RouteSettings routeSettings) =>
          AppRoute.generateRoute(routeSettings),
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => EventListPage(),
      ),
    );
  }
}
