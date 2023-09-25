import 'package:get/get.dart';
import 'package:iboxnav/controllers/auth/auth_controller.dart';
import 'package:iboxnav/core/network/api_provider.dart';
import 'package:iboxnav/core/network/api_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiProvider(), permanent: true);
    Get.put(ApiService(Get.find()), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
