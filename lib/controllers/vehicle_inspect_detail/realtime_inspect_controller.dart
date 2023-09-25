import 'dart:async';

import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:floating_pullup_card/floating_pullup_card.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_detail_controller.dart';
import 'package:iboxnav/models/event_data_model.dart';
import 'package:iboxnav/models/vehicle_model.dart';
import 'package:iboxnav/repositories/vehicle_repository.dart';

class RealtimeInspectController extends GetxController {
  final InspectDetailController controller;
  RealtimeInspectController(this.controller);
  final bottomSheetController = BottomSheetBarController();

  final VehicleRepository _vehicle = Get.find();
  var bottomState = FloatingPullUpState.collapsed.obs;
  var eventData = EventDataModel.empty().obs;
  VehicleModel? vehicleModel;
  EventDataModel? lastModel;
  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(21.037268, 105.836026), zoom: 16);
  //
  var eventModels = <EventDataModel>{}.obs;

  EventDataModel? get getLastModel {
    return eventModels.lastOrNull;
  }

  void clearData() {
    eventModels.value.clear();
  }

  Future<void> initData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await getVehicleId(controller.vehicleId);
    lastModel = await _vehicle.getEventData(vehicleModel!);
    eventData.value = lastModel!;
    eventModels.add(lastModel!);
  }

  Future<void> getVehicleId(String vehicleId) async {
    vehicleModel = await _vehicle.getOneByLicenseId(vehicleId);
  }

  Future<void> getNextEventData() async {
    if (lastModel == null) return;
    List<EventDataModel> models = await _vehicle.getNextEventData(lastModel!);
    lastModel = models.lastOrNull;
    eventData.value = lastModel!;
    eventModels.addAll(models);
  }

  void setBottomState(FloatingPullUpState state) {
    bottomState.value = state;
    bottomState.refresh();
  }
}
