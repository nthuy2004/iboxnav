import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iboxnav/config/constants.dart';
import 'package:iboxnav/core/extensions/extensions.dart';
import 'package:iboxnav/models/vehicle_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vector_math/vector_math.dart' as super_math;
import 'dart:ui' as ui;
import 'package:xml/xml.dart' as xml;
import 'dart:math' as math;

class Utility {
  static Color getFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String getBasicToken(String username, String password) {
    return base64.encode(utf8.encode("$username:$password"));
  }

  static Widget renderIfTrue(bool conditional, {required Widget child}) {
    return conditional ? child : SizedBox.shrink();
  }

  static String readTimestamp(int timestamp,
      {String format = Constants.DATETIME_FORMAT}) {
    DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return formatDatetime(date1, format: format);
  }

  static Future<String?> getRelativeAddressFromGeographic(LatLng geo) async {
    try {
      Response res = await Dio().get(
          "https://nominatim.openstreetmap.org/reverse?lat=${geo.latitude}&lon=${geo.longitude}",
          options: Options(
            sendTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ));
      final document = xml.XmlDocument.parse(res.toString());

      final reversegeocode = document.findElements('reversegeocode').first;
      final result = reversegeocode.findElements("result").first;
      return result.innerText;
    } catch (e) {
      return "Không xác định";
    }
  }

  static String formatDatetime(DateTime d,
      {String format = Constants.DATETIME_FORMAT}) {
    return DateFormat(format).format(d);
  }

  static (String, Color) getStatusText(VehicleModel model) {
    if (model.status == VehicleStatus.Running) {
      return ("Đang chạy", Colors.green[500]!);
    }
    if (model.status == VehicleStatus.Parking) {
      return ("Đang đỗ", Colors.amber[500]!);
    }
    return ("Đang dừng", Colors.red);
  }

  // convert seconds to Hours:Minutes:Seconds format
  static String secondToHMS(int seconds, {bool withSeconds = true}) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr${withSeconds ? ":$secondsStr" : ""}';
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static double calculateBearing(LatLng l1, LatLng l2) {
    // GPT heheh
    double degToRad = pi / 180.0;
    double phi1 = l1.latitude * degToRad;
    double phi2 = l2.latitude * degToRad;
    double deltaLambda = (l2.longitude - l1.longitude) * degToRad;

    double y = sin(deltaLambda) * cos(phi2);
    double x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(deltaLambda);
    double bearing = atan2(y, x);

    // Convert bearing from radians to degrees
    double bearingDegrees = (bearing * 180.0) / pi;

    // Normalize bearing to the range [0, 360)
    double normalizedBearing = (bearingDegrees + 360.0) % 360.0;

    return normalizedBearing;
  }
}
