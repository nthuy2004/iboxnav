import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDataRangeModel {
  String vehicleId;
  int timestamp;
  double lat;
  double lng;

  EventDataRangeModel({
    required this.vehicleId,
    required this.timestamp,
    required this.lat,
    required this.lng,
  });

  LatLng getPos() => LatLng(lat, lng);

  factory EventDataRangeModel.fromJson(Map<String, dynamic> json) =>
      EventDataRangeModel(
        vehicleId: json["vehicleId"],
        timestamp: json["timestamp"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "vehicleId": vehicleId,
        "timestamp": timestamp,
        "lat": lat,
        "lng": lng,
      };
}
