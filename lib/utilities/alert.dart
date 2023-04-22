import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController alert(String title, String body,
    {Color backgroundColor = Colors.red, Color colorText = Colors.white}) {
  return Get.snackbar(
    title,
    body,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: backgroundColor,
    colorText: colorText,
    margin: const EdgeInsets.all(16.0),
    borderRadius: 10.0,
    animationDuration: const Duration(milliseconds: 500),
    duration: const Duration(seconds: 1),
  );
}
