import 'dart:io';
import 'package:flutter/material.dart';

void showSnackBarView(
    BuildContext context, String message, Color backGroundColor) {
  SnackBar snackBarContent = SnackBar(
    duration: Duration(seconds: 2),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
    ),
    backgroundColor: backGroundColor,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    margin: Platform.isIOS
        ? const EdgeInsets.all(20)
        : EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        right: 20,
        left: 20),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
}