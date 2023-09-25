import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/vehicle_model.dart';
import 'package:iboxnav/repositories/vehicle_repository.dart';

class VehicleDetailController extends GetxController with StateMixin {
  final VehicleRepository _vehicle;
  VehicleDetailController(this._vehicle);

  @override
  void onReady() {
    init();
  }

  void init() {
    String? id_str = Get.parameters["id"];
    if (id_str == null || id_str.isEmpty) {
      return;
    }
    getOne(int.parse(id_str));
  }

  getOne(int vehicleid) async {
    try {
      change(null, status: RxStatus.loading());
      VehicleModel model = await _vehicle.getOne(vehicleid);
      String? addr = await Utility.getRelativeAddressFromGeographic(
          LatLng(model.lat, model.lng));
      change({"model": model, "addr": addr}, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error("${e}"));
    }
  }
}
