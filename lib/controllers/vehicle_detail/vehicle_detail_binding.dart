import 'package:get/get.dart';
import 'package:iboxnav/controllers/vehicle_detail/vehicle_detail_controller.dart';

class VehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleDetailController>(
        () => VehicleDetailController(Get.find()));
  }
}
