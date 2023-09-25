import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iboxnav/presentation/pages/utility/utility_page.dart';
import 'package:iboxnav/presentation/pages/vehicle_inspect/vehicle_inspect_page.dart';
import 'package:iboxnav/presentation/pages/vehicle_list/vehicle_list_page.dart';
import 'package:iboxnav/presentation/pages/vehicle_report/vehicle_report_page.dart';

class HomeController extends GetxController {
  var currentPage = 0.obs;
  List<Widget> pageList = const [
    VehicleListPage(),
    CarInspectPage(),
    VehicleReportPage(),
    UtilityPage(),
  ];

  void goToPage(int index) {
    if (currentPage.value != index) {
      currentPage.value = index;
    }
  }
}
