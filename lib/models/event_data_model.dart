import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDataModel {
  String deviceId;
  String vehicleId;
  int timestamp;
  String driverName;
  double lat;
  double lng;
  int speed;
  int status;
  int doorOpen;
  int overSpeed;
  int workedTime;
  int workingTime;
  int workedKm;
  int noStop;
  String? address;

  EventDataModel({
    required this.deviceId,
    required this.vehicleId,
    required this.timestamp,
    required this.driverName,
    required this.lat,
    required this.lng,
    required this.speed,
    required this.status,
    required this.doorOpen,
    required this.overSpeed,
    required this.workedTime,
    required this.workingTime,
    required this.workedKm,
    required this.noStop,
    this.address,
  });
  @override
  bool operator ==(Object other) {
    if (other is! EventDataModel) return false;
    return lat == other.lat &&
        lng == other.lng &&
        speed == other.speed &&
        status == other.status;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + lat.hashCode;
    result = 37 * result + lng.hashCode;
    result = 37 * result + speed.hashCode;
    result = 37 * result + status.hashCode;
    return result;
  }

  LatLng getPos() {
    return LatLng(lat, lng);
  }

  factory EventDataModel.empty() => EventDataModel(
      deviceId: "",
      vehicleId: "",
      timestamp: 0,
      driverName: "",
      lat: 0,
      lng: 0,
      speed: 0,
      status: 0,
      doorOpen: 0,
      overSpeed: 0,
      workedTime: 0,
      workingTime: 0,
      workedKm: 0,
      noStop: 0);
  factory EventDataModel.fromJson(Map<String, dynamic> json) => EventDataModel(
        deviceId: json["deviceId"],
        vehicleId: json["vehicleId"],
        timestamp: json["timestamp"],
        driverName: json["driverName"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        speed: json["speed"],
        status: json["status"],
        doorOpen: json["doorOpen"],
        overSpeed: json["overSpeed"],
        workedTime: json["workedTime"],
        workingTime: json["workingTime"],
        workedKm: json["workedKm"],
        noStop: json["noStop"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "vehicleId": vehicleId,
        "timestamp": timestamp,
        "driverName": driverName,
        "lat": lat,
        "lng": lng,
        "speed": speed,
        "status": status,
        "doorOpen": doorOpen,
        "overSpeed": overSpeed,
        "workedTime": workedTime,
        "workingTime": workingTime,
        "workedKm": workedKm,
        "noStop": noStop,
        "address": address,
      };
}
