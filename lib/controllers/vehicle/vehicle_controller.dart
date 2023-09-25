import 'package:get/get.dart';
import 'package:iboxnav/models/vehicle_model.dart';
import 'package:iboxnav/repositories/vehicle_repository.dart';

class VehicleController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  final VehicleRepository _vehicle;
  VehicleController(this._vehicle);

  var vehicles = <VehicleModel>[].obs;

  getVehicles() async {
    List<VehicleModel> items = await _vehicle.getVehicles();
    vehicles.clear();
    vehicles.addAll(items);
  }
}
