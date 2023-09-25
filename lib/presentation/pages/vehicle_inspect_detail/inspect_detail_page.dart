import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_detail_controller.dart';
import 'package:iboxnav/core/utils/dialog.dart';
import 'package:iboxnav/presentation/pages/vehicle_inspect_detail/bottom_nav_bar.dart';

class InspectDetailPage extends GetView<InspectDetailController> {
  const InspectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Obx(() => Scaffold(
              bottomNavigationBar: const BottomNavBar(),
              body: SafeArea(
                  child: Stack(
                children: [
                  controller.pages[controller.currentPage.value],
                  Positioned(
                      top: 20,
                      left: 20,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey[300]!,
                                    offset: const Offset(
                                      2.0,
                                      2.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2),
                              ],
                              borderRadius:
                                  BorderRadius.circular(15.0)), //<-- SEE HERE
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100.0),
                            onTap: () {
                              Get.back();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                FontAwesomeIcons.arrowLeft,
                                size: 30.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              )),
            )),
        onWillPop: () async {
          return await GetDialogEx.confirm(
              title: "Xác nhận!", message: "Bạn có muốn thoát trang ?");
        });
  }
}
