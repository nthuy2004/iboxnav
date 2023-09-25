import 'package:get/get.dart';
import 'package:iboxnav/repositories/report_repository.dart';

class VehicleReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportRepository());
  }
}
