import 'package:get/get.dart';
import 'package:iboxnav/controllers/vehicle/vehicle_controller.dart';
import 'package:iboxnav/repositories/vehicle_repository.dart';

class VehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleRepository>(() => VehicleRepository());
    Get.lazyPut<VehicleController>(() => VehicleController(Get.find()));
  }
}
