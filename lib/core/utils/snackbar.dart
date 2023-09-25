import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class GetSnackbarEx {
  static normal({String? title, String? message, IconData? icon}) {
    base(
        title: title,
        message: message,
        icon: icon,
        variant: SnackVariant.Normal);
  }

  static success(
      {String? title,
      String? message,
      IconData? icon = FontAwesomeIcons.check}) {
    base(
        title: title,
        message: message,
        icon: icon,
        variant: SnackVariant.Success);
  }

  static warning(
      {String? title,
      String? message,
      IconData? icon = FontAwesomeIcons.circleExclamation}) {
    base(
        title: title,
        message: message,
        icon: icon,
        variant: SnackVariant.Warning);
  }

  static error(
      {String? title,
      String? message,
      IconData? icon = FontAwesomeIcons.triangleExclamation}) {
    base(
        title: title,
        message: message,
        icon: icon,
        variant: SnackVariant.Error);
  }

  static base(
      {String? title,
      String? message,
      IconData? icon,
      SnackVariant variant = SnackVariant.Normal}) {
    Get.showSnackbar(
      GetSnackBar(
        shouldIconPulse: false,
        title: title,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        message: message,
        icon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              icon,
              color: getVariant(variant),
            )),
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  static Color getVariant(SnackVariant variant) {
    switch (variant) {
      case SnackVariant.Normal:
        return Colors.lightBlue;
      case SnackVariant.Success:
        return Colors.green[500]!;
      case SnackVariant.Error:
        return Colors.red;
      case SnackVariant.Warning:
        return Colors.yellow[600]!;
      default:
        return Color(0xF8F8F8);
    }
  }
}

// ignore: constant_identifier_names
enum SnackVariant { Normal, Success, Error, Warning }
