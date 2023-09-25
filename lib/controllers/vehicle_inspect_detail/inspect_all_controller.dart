import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_detail_controller.dart';
import 'package:iboxnav/models/event_data_model.dart';
import 'package:iboxnav/models/event_data_range_model.dart';
import 'package:iboxnav/repositories/vehicle_repository.dart';

class InspectAllController extends GetxController {
  final bottomSheetController = BottomSheetBarController();
  final InspectDetailController controller;
  InspectAllController(this.controller);
  var eventData = EventDataModel.empty().obs;
  final VehicleRepository _vehicle = Get.find();

  var eventModels = <EventDataRangeModel>[].obs;

  Future<void> initData() async {
    eventModels.value = await controller.getVehicleRangeData();
    if (eventModels.isEmpty) throw "getVehicleRangeData return empty!";
    await getEventData(eventModels.first.timestamp);
  }

  Future<void> getEventData(int timestamp) async {
    if (timestamp == eventData.value.timestamp) return;
    eventData.value =
        await _vehicle.baseGetEventData(controller.vehicleId, timestamp);
    bottomSheetController.expand();
  }
}
