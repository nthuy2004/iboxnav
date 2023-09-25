import 'package:get/get.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_all_controller.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_detail_controller.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_range_controller.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/realtime_inspect_controller.dart';
import 'package:iboxnav/repositories/vehicle_repository.dart';

class InspectDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VehicleRepository());
    Get.put(InspectDetailController());
    Get.lazyPut(() => RealtimeInspectController(Get.find()));
    Get.lazyPut(() => InspectAllController(Get.find()));
    Get.lazyPut(() => InspectRangeController(Get.find()));
  }
}
