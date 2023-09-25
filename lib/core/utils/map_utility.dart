import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:vector_math/vector_math.dart';

Future<BitmapDescriptor> getBitmapDescriptorFromSvgAsset(
  String assetName, {
  Size size = const Size(48, 48),
}) async {
  try {
    final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);

    double devicePixelRatio = ui.window.devicePixelRatio;
    int width = (size.width * devicePixelRatio).toInt();
    int height = (size.height * devicePixelRatio).toInt();

    final scaleFactor = min(
      width / pictureInfo.size.width,
      height / pictureInfo.size.height,
    );

    final recorder = ui.PictureRecorder();

    ui.Canvas(recorder)
      ..scale(scaleFactor)
      ..drawPicture(pictureInfo.picture);

    final rasterPicture = recorder.endRecording();

    final image = rasterPicture.toImageSync(width, height);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  } catch (e) {
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
  }
}

double getBearing(LatLng begin, LatLng end) {
  double lat = (begin.latitude - end.latitude).abs();

  double lng = (begin.longitude - end.longitude).abs();

  if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
    return degrees(atan(lng / lat));
  } else if (begin.latitude >= end.latitude &&
      begin.longitude < end.longitude) {
    return (90 - degrees(atan(lng / lat))) + 90;
  } else if (begin.latitude >= end.latitude &&
      begin.longitude >= end.longitude) {
    return degrees(atan(lng / lat)) + 180;
  } else if (begin.latitude < end.latitude &&
      begin.longitude >= end.longitude) {
    return (90 - degrees(atan(lng / lat))) + 270;
  }

  return -1;
}

double getDistanceFromTwoLatLng(LatLng from, LatLng to) {
  double lat1 = from.latitude;
  double lon1 = from.longitude;

  double lat2 = to.latitude;
  double lon2 = to.longitude;
  const int earthRadius = 6371;
  double latDistance = radians(lat2 - lat1);
  double lonDistance = radians(lon2 - lon1);

  double a = pow(sin(latDistance / 2), 2) +
      cos(radians(lat1)) * cos(radians(lat2)) * pow(sin(lonDistance / 2), 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = earthRadius * c;

  return distance * 1000;
}
