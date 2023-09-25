class VehicleModel {
  int id;
  String deviceId;
  String vehicleId;
  double lat;
  double lng;
  int timestamp;
  int speed;
  int engine;
  int engineTime;
  int engineKm;
  int speedLimit;
  String? driverName;
  String? phoneNumber;
  String? driverLicenseNumber;
  String? username;

  bool get _isRunning => speed > 0;
  bool get _isParking => !_isRunning && engine == 0;
  VehicleStatus get status {
    if (_isRunning) return VehicleStatus.Running;
    if (_isParking) return VehicleStatus.Parking;
    return VehicleStatus.Stopped;
  }

  VehicleModel(
      {required this.id,
      required this.deviceId,
      required this.vehicleId,
      required this.lat,
      required this.lng,
      required this.timestamp,
      required this.speed,
      required this.engine,
      required this.engineTime,
      required this.engineKm,
      required this.speedLimit,
      this.driverName,
      this.phoneNumber,
      this.driverLicenseNumber,
      this.username});

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
      id: json["id"],
      deviceId: json["deviceId"],
      vehicleId: json["vehicleId"],
      lat: json["lat"]?.toDouble(),
      lng: json["lng"]?.toDouble(),
      timestamp: json["timestamp"] ?? 0,
      speed: json["speed"],
      engine: json["engine"],
      engineTime: json["engineTime"],
      engineKm: json["engineKm"],
      speedLimit: json["speedLimit"],
      driverName: json["driverName"],
      phoneNumber: json["phoneNumber"],
      driverLicenseNumber: json["driverLicenseNumber"],
      username: json["username"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "deviceId": deviceId,
        "vehicleId": vehicleId,
        "lat": lat,
        "lng": lng,
        "timestamp": timestamp,
        "speed": speed,
        "engine": engine,
        "engineTime": engineTime,
        "engineKm": engineKm,
        "speedLimit": speedLimit,
        "driverName": driverName,
        "phoneNumber": phoneNumber,
        "driverLicenseNumber": driverLicenseNumber,
        "username": username
      };
}

// ignore: constant_identifier_names
enum VehicleStatus { Running, Parking, Stopped }
