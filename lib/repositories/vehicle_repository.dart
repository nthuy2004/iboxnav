import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:iboxnav/core/network/api_service.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/event_data_model.dart';
import 'package:iboxnav/models/event_data_range_model.dart';
import 'package:iboxnav/models/vehicle_model.dart';
import 'package:iboxnav/core/extensions/extensions.dart';

class VehicleRepository {
  final ApiService _api = Get.find();
  Future<List<VehicleModel>> getVehicles() async {
    dio.Response response = await _api.get("/v2.0/vehicle");
    if (!response.isOK()) throw "Fail to get a vehicles list";

    Iterable decoded = json.decode(response.data);
    return List<VehicleModel>.from(
        decoded.map((model) => VehicleModel.fromJson(model)));
  }

  Future<VehicleModel> getOne(int id) async {
    try {
      dio.Response response = await _api.get("/v2.0/vehicle/$id");
      return VehicleModel.fromJson(json.decode(response.data));
    } catch (e) {
      throw "Fail to get a vehicle info";
    }
  }

  Future<VehicleModel> getOneByLicenseId(String vehicleId) async {
    try {
      VehicleModel currentVehicle = (await getVehicles())
          .firstWhere((element) => element.vehicleId == vehicleId);
      return currentVehicle;
    } catch (e) {
      throw "getOneByLicenseId throw an error";
    }
  }

  Future<EventDataModel> getEventData(VehicleModel model) async {
    return await baseGetEventData(model.vehicleId, model.timestamp);
  }

  Future<EventDataModel> baseGetEventData(
      String vehicleId, int timestamp) async {
    try {
      dio.Response response = await _api.get("/v1.0/eventdata",
          query: {"vehicleId": vehicleId, "timestamp": timestamp});
      return EventDataModel.fromJson(json.decode(response.data));
    } catch (e) {
      throw "getEventData throw an error";
    }
  }

  Future<List<EventDataModel>> getNextEventData(
      EventDataModel lastModel) async {
    try {
      dio.Response response = await _api.get("/v1.0/eventdata/nextRow", query: {
        "vehicleId": lastModel.vehicleId,
        "timestamp": lastModel.timestamp.toString()
      });
      if (!response.isOK()) return [];
      Iterable decoded = json.decode(response.data);
      return List<EventDataModel>.from(
          decoded.map((model) => EventDataModel.fromJson(model)));
    } catch (e) {
      throw "getNextEventData throw an error";
    }
  }

  Future<List<EventDataRangeModel>> getVehicleRangeData(
      {required String vehicleId,
      required DateTime start,
      required DateTime end}) async {
    try {
      dio.Response response = await _api.get("/v1.0/eventdata/range", query: {
        "vehicleId": vehicleId,
        "startTime": Utility.formatDatetime(start),
        "endTime": Utility.formatDatetime(end),
      });
      if (!response.isOK()) throw "getVehicleRangeData throw an error";

      Iterable decoded = json.decode(response.data);
      return List<EventDataRangeModel>.from(
          decoded.map((model) => EventDataRangeModel.fromJson(model)));
    } catch (e) {
      throw "getVehicleRangeData throw an error";
    }
  }
}
