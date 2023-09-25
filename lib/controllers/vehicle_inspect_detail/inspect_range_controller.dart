import 'dart:async';

import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_detail_controller.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/event_data_model.dart';
import 'package:iboxnav/models/event_data_range_model.dart';
import 'package:iboxnav/repositories/vehicle_repository.dart';
import 'package:pausable_timer/pausable_timer.dart';

class InspectRangeController extends GetxController {
  final VehicleRepository _vehicle = Get.find();
  final bottomSheetController = BottomSheetBarController();

  final Map<double, Duration> speed = {
    1: const Duration(milliseconds: 800),
    2: const Duration(milliseconds: 500),
  };
  double currentSpeed = 1;
  var currentDuration = Duration(milliseconds: 800).obs;

  final beginMarkerId = const MarkerId("begin");
  final endMarkerId = const MarkerId("end");
  final vehicleMarkerId = const MarkerId("vehicle");

  final InspectDetailController controller;
  InspectRangeController(this.controller);
  final kDuration = const Duration(milliseconds: 1000);

  var vehiclePos = const LatLng(0, 0).obs;
  var currentCameraZoom = 14.1.obs;
  var counter = 0.obs;
  PausableTimer? timer;
  var markers = <MarkerId, Marker>{}.obs;
  CameraPosition cameraPos = const CameraPosition(
    target: LatLng(10.948753, 106.835568),
    zoom: 14.4746,
  );
  List<EventDataRangeModel> eventModels = [];
  var state = PlayingState.Stopped.obs;
  var eventData = EventDataModel.empty().obs;

  Future<void> initData() async {
    counter.value = 0;
    markers.clear();
    eventModels = await controller.getVehicleRangeData();
    cameraPos = CameraPosition(target: eventModels.first.getPos(), zoom: 18);
    markers[beginMarkerId] = Marker(
      markerId: beginMarkerId,
      position: eventModels.first.getPos(),
      icon: controller.startIcon,
      flat: true,
    );
    markers[endMarkerId] = Marker(
      markerId: endMarkerId,
      position: eventModels.last.getPos(),
      icon: controller.endIcon,
      flat: true,
    );
    markers[vehicleMarkerId] = Marker(
        markerId: const MarkerId("vehicleMarker"),
        position: eventModels.first.getPos(),
        icon: controller.vehicleIcon);
    vehiclePos.value = eventModels.first.getPos();
    startStream();
  }

  Set<EventDataRangeModel> get processedEvents {
    Set<EventDataRangeModel> res = {};
    for (final (i, _) in eventModels.indexed) {
      res.addIf(
          i % 4 == 0 || i == eventModels.length - 1, eventModels.elementAt(i));
    }
    return res;
  }

  Future<void> getEventData(int timestamp) async {
    if (timestamp == eventData.value.timestamp) return;
    eventData.value =
        await _vehicle.baseGetEventData(controller.vehicleId, timestamp);
    bottomSheetController.expand();
  }

  Set<Marker> get getMarkers {
    Set<Marker> res = {};
    int eventLength = eventModels.length;
    BitmapDescriptor getMarker(int i) {
      if (i == 0) return controller.startIcon;
      if (i == eventLength - 1) return controller.vehicleIcon;
      if (i != 0 && i % 4 == 0)
        return controller.flagIcon;
      else
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
    }

    double bearing(int i) {
      if (i == eventLength - 1 && eventLength > 2) {
        return Utility.calculateBearing(eventModels.elementAt(i - 1).getPos(),
            eventModels.elementAt(i).getPos());
      }
      return -1;
    }

    for (final (i, v) in eventModels.indexed) {
      res.addIf(
          i % 4 == 0 || i == eventLength - 1,
          Marker(
            markerId: MarkerId("${v.timestamp}"),
            position: v.getPos(),
            icon: getMarker(i),
            rotation: bearing(i),
            flat: true,
            onTap: () async {},
          ));
    }

    return res;
  }

  void startStream() {
    if (state.value == PlayingState.Stopped) {
      counter.value = 0;
    }
    timer = PausableTimer(speed[currentSpeed]!, () {
      if (counter.value == processedEvents.length - 1) {
        state.value = PlayingState.Stopped;
      } else {
        timer!
          ..reset()
          ..start();
      }
      counter.value++;
      vehiclePos.value = processedEvents.elementAt(counter.value).getPos();
    })
      ..start();
    state.value = PlayingState.Playing;
  }

  void resumeStream() {
    state.value = PlayingState.Playing;
    if (timer != null) {
      timer!
        ..reset()
        ..start();
    }
  }

  void stopStream() {
    state.value = PlayingState.Stopped;
    counter.value = 0;
    if (eventModels.isNotEmpty) {
      vehiclePos.value = eventModels.first.getPos();
    }
    if (timer != null) timer!.cancel();
  }

  void pauseStream() {
    state.value = PlayingState.Paused;
    if (timer != null) timer!.pause();
  }

  void toggleStream() {
    if (state.value == PlayingState.Stopped) {
      startStream();
      return;
    }
    if (state.value == PlayingState.Paused) {
      resumeStream();
    } else {
      pauseStream();
    }
  }

  void onSpeedChange(double newSpeed) {
    currentSpeed = newSpeed;
    currentDuration.value = speed[currentSpeed]!;
    pauseStream();
    startStream();
  }
}

enum PlayingState { Playing, Paused, Stopped }
