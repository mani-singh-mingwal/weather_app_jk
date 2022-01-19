import 'package:flutter/material.dart';

Widget getMaterialBtn(BuildContext context, onPressed) {
  return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      child: const Text(
        "Search",
        style: TextStyle(color: Colors.white70),
      ),
      color: Colors.blue,
      onPressed: onPressed);
}
