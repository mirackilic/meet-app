import 'package:flutter/material.dart';
import 'package:meet_app/constans.dart';

AppBar beymenAppbar(String title, Function()? onPressed) {
  return AppBar(
    // automaticallyImplyLeading: showBackButton,
    backgroundColor: mainColor,
    centerTitle: true,
    elevation: 4.0,
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: 'Open shopping cart',
        onPressed: onPressed,
      ),
    ],
  );
}
