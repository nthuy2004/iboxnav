class WorkReportModel {
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
    int? km;
    int? time;
    int? over4H;

    WorkReportModel({
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
        this.km,
        this.time,
        this.over4H,
    });

    factory WorkReportModel.fromJson(Map<String, dynamic> json) => WorkReportModel(
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
        km: json["km"],
        time: json["time"],
        over4H: json["over4H"],
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
        "km": km,
        "time": time,
        "over4H": over4H,
    };
}