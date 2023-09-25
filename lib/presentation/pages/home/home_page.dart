import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/home/home_controller.dart';
import 'package:iboxnav/core/utils/dialog.dart';
import 'package:iboxnav/presentation/pages/home/bottom_nav_bar.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      int initialPageIndex = 0;
      if (controller.currentPage.value != initialPageIndex) {
        controller.goToPage(initialPageIndex);
        return false;
      } else {
        return await GetDialogEx.confirm(message: "Bạn có muốn thoát ứng dụng");
      }
    }

    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: Obx(
          () => WillPopScope(
              child: controller.pageList[controller.currentPage.value],
              onWillPop: () async {
                return onWillPop();
              }),
        ));
  }
}
