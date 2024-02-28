import 'package:flutter/material.dart';
import 'package:meet_app/pages/calendar/calendar_list_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        // initialRoute: ,
        home: CalendarListPage()
        );
  }
}
