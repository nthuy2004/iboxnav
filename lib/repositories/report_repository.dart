import 'dart:convert';

import 'package:get/get.dart';
import 'package:iboxnav/core/extensions/extensions.dart';
import 'package:iboxnav/core/network/api_service.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/report_model/detail_work_report_model.dart';
import 'package:iboxnav/models/report_model/overspeed_report_model.dart';
import 'package:iboxnav/models/report_model/parking_report_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:iboxnav/models/report_model/work_report_model.dart';

typedef FutureReportFunction<T> = Future<List<T>> Function(
    String, DateTime, DateTime);

class ReportRepository {
  final ApiService _api = Get.find();
  Future<List<ParkingReportModel>> getParkingReport(
      String vehicleId, DateTime start, DateTime end) async {
    dio.Response response = await _api.get("/v1.0/report/1", query: {
      "vehicleId": vehicleId,
      "startTime": Utility.formatDatetime(start),
      "endTime": Utility.formatDatetime(end),
    });
    if (!response.isOK()) throw "getParkingReport throw an error";

    Iterable decoded = json.decode(response.data);
    return List<ParkingReportModel>.from(
        decoded.map((model) => ParkingReportModel.fromJson(model)));
  }

  Future<List<WorkReportModel>> getWorkReport(
      String vehicleId, DateTime start, DateTime end) async {
    dio.Response response = await _api.get("/v1.0/report/5", query: {
      "vehicleId": vehicleId,
      "startTime": Utility.formatDatetime(start),
      "endTime": Utility.formatDatetime(end),
    });
    if (!response.isOK()) throw "getWorkReport throw an error";

    Iterable decoded = json.decode(response.data);
    return List<WorkReportModel>.from(
        decoded.map((model) => WorkReportModel.fromJson(model)));
  }

  Future<List<OverspeedReportModel>> getOverspeedReport(
      String vehicleId, DateTime start, DateTime end) async {
    dio.Response response = await _api.get("/v1.0/report/3", query: {
      "vehicleId": vehicleId,
      "startTime": Utility.formatDatetime(start),
      "endTime": Utility.formatDatetime(end),
    });
    if (!response.isOK()) throw "getOverspeedReport throw an error";

    Iterable decoded = json.decode(response.data);
    return List<OverspeedReportModel>.from(
        decoded.map((model) => OverspeedReportModel.fromJson(model)));
  }

  Future<List<DetailWorkReportModel>> getDetailWorkReport(
      String vehicleId, DateTime start, DateTime end) async {
    dio.Response response = await _api.get("/v1.0/report/4", query: {
      "vehicleId": vehicleId,
      "startTime": Utility.formatDatetime(start),
      "endTime": Utility.formatDatetime(end),
    });
    if (!response.isOK()) throw "getDetailWorkReport throw an error";

    Iterable decoded = json.decode(response.data);
    return List<DetailWorkReportModel>.from(
        decoded.map((model) => DetailWorkReportModel.fromJson(model)));
  }

  Future<List<ParkingReportModel>> getDoorOpenReport(
      String vehicleId, DateTime start, DateTime end) async {
    return [];
  }
}
