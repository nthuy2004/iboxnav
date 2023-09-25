import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iboxnav/core/utils/map_utility.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/event_data_model.dart';
import 'package:iboxnav/models/event_data_range_model.dart';
import 'package:iboxnav/models/vehicle_model.dart';
import 'package:iboxnav/presentation/components/loading.dart';
import 'package:iboxnav/presentation/pages/vehicle_inspect_detail/pages/inspect_range.dart';
import 'package:iboxnav/presentation/pages/vehicle_inspect_detail/pages/realtime_inspect.dart';
import 'package:iboxnav/presentation/pages/vehicle_inspect_detail/pages/inspect_all.dart';
import 'package:iboxnav/repositories/vehicle_repository.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:loader_overlay/loader_overlay.dart';

class InspectDetailController extends GetxController {
  final VehicleRepository _vehicle = Get.find();

  BitmapDescriptor startIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor endIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor vehicleIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor flagIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor parkIcon = BitmapDescriptor.defaultMarker;

  String mapStyle = "";
  final List<Widget> pages = const [
    RealtimeInspect(),
    InspectAll(),
    InspectRange()
  ];

  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(21.037268, 105.836026), zoom: 16);

  var realtimeOnly = false.obs; // only for VechicleDetail navigate to Inspect
  var currentPage = 0.obs;
  var vehicleId = "";
  var startDate = DateTime.now();
  var endDate = DateTime.now();

  @override
  void onInit() async {
    /// 0: vehicleId, 1: startDate, 2: endDate
    if (Get.arguments[0] != null) {
      vehicleId = Get.arguments[0];
    }
    if (Get.arguments[1] != null && Get.arguments[2] != null) {
      startDate = Get.arguments[1] as DateTime;
      endDate = Get.arguments[2] as DateTime;
    } else {
      realtimeOnly.value = true;
    }
    await initMapStyle();
    await initMarkerIcon();
    setCurrentPage(0);
    super.onInit();
  }

  Future<void> initMapStyle() async {
    mapStyle = await rootBundle.loadString('assets/data/map_light.json');
  }

  Future<void> initMarkerIcon() async {
    try {
      startIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      vehicleIcon = BitmapDescriptor.fromBytes(await Utility.getBytesFromAsset(
          'assets/images/vehicle_marker.png', 30));
      flagIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "assets/images/red_flag.png");
      parkIcon = await getBitmapDescriptorFromSvgAsset(
          "assets/images/park_marker.svg");
    } catch (e) {}
  }

  void setCurrentPage(int index) {
    if (currentPage.value != index) {
      currentPage.value = index;
    }
  }

  Future<List<EventDataRangeModel>> getVehicleRangeData() async {
    try {
      return await _vehicle.getVehicleRangeData(
          vehicleId: vehicleId, start: startDate, end: endDate);
    } catch (e) {
      return [];
    }
  }

  Future<EventDataModel?> getEventData(VehicleModel model) async {
    return _vehicle.getEventData(model);
  }

  void showLoading(BuildContext context) {
    context.loaderOverlay.show(
        widget: LoadingWidget(
      withRectangle: true,
      text: "Đang lấy dữ liệu...",
    ));
  }

  void hideLoading(BuildContext context) {
    context.loaderOverlay.hide();
  }
}
