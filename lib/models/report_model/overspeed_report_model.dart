class OverspeedReportModel {
  int? id;
  String? deviceId;
  String? vehicleId;
  String? driverName;
  int? startTime;
  int? endTime;
  double? startLat;
  double? startLng;
  double? endLat;
  double? endLng;
  String? startAddress;
  String? endAddress;
  int? overSpeed;
  int? maxSpeed;
  int? overTime;
  int? overKm;
  int? limitSpeed;

  OverspeedReportModel({
    this.id,
    this.deviceId,
    this.vehicleId,
    this.driverName,
    this.startTime,
    this.endTime,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
    this.startAddress,
    this.endAddress,
    this.overSpeed,
    this.maxSpeed,
    this.overTime,
    this.overKm,
    this.limitSpeed,
  });

  factory OverspeedReportModel.fromJson(Map<String, dynamic> json) =>
      OverspeedReportModel(
        id: json["id"],
        deviceId: json["deviceId"],
        vehicleId: json["vehicleId"],
        driverName: json["driverName"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        startLat: json["startLat"]?.toDouble(),
        startLng: json["startLng"]?.toDouble(),
        endLat: json["endLat"]?.toDouble(),
        endLng: json["endLng"]?.toDouble(),
        startAddress: json["startAddress"],
        endAddress: json["endAddress"],
        overSpeed: json["overSpeed"],
        maxSpeed: json["maxSpeed"],
        overTime: json["overTime"],
        overKm: json["overKm"],
        limitSpeed: json["limitSpeed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deviceId": deviceId,
        "vehicleId": vehicleId,
        "driverName": driverName,
        "startTime": startTime,
        "endTime": endTime,
        "startLat": startLat,
        "startLng": startLng,
        "endLat": endLat,
        "endLng": endLng,
        "startAddress": startAddress,
        "endAddress": endAddress,
        "overSpeed": overSpeed,
        "maxSpeed": maxSpeed,
        "overTime": overTime,
        "overKm": overKm,
        "limitSpeed": limitSpeed,
      };
}
