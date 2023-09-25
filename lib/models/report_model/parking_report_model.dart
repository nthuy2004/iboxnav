class ParkingReportModel {
  int? id;
  String? deviceId;
  String? vehicleId;
  String? driverName;
  int? startTime;
  int? endTime;
  double? lat;
  double? lng;
  String? address;
  int? noStop;
  int? isStop;
  int? totalTime;

  ParkingReportModel({
    this.id,
    this.deviceId,
    this.vehicleId,
    this.driverName,
    this.startTime,
    this.endTime,
    this.lat,
    this.lng,
    this.address,
    this.noStop,
    this.isStop,
    this.totalTime,
  });

  factory ParkingReportModel.fromJson(Map<String, dynamic> json) =>
      ParkingReportModel(
        id: json["id"],
        deviceId: json["deviceId"],
        vehicleId: json["vehicleId"],
        driverName: json["driverName"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        address: json["address"],
        noStop: json["noStop"],
        isStop: json["isStop"],
        totalTime: json["totalTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deviceId": deviceId,
        "vehicleId": vehicleId,
        "driverName": driverName,
        "startTime": startTime,
        "endTime": endTime,
        "lat": lat,
        "lng": lng,
        "address": address,
        "noStop": noStop,
        "isStop": isStop,
        "totalTime": totalTime,
      };
}
