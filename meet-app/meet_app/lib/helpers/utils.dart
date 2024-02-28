import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  date = date.add(const Duration(hours: 3));
  var formatter = DateFormat('d MMMM HH:mm', 'tr');
  return formatter.format(date);
}

String formatDateForCreateMeet(DateTime date) {
  var formatter = DateFormat('d MMMM yyyy', 'tr');
  return formatter.format(date);
}

String formatDateForCalendar(DateTime date) {
  return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(date);
}

void buildRequestFailedAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('HATA'),
        content: const Text("Request failed"),
        actions: [
          ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 0, 101, 255))),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("TAMAM", style: TextStyle(color: Colors.white)))
        ],
      );
    },
  );
}
