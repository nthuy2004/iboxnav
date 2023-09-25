import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_detail_controller.dart';

List<BottomItemModel> listItems = [
  BottomItemModel(
      iconAsset: FontAwesomeIcons.mapLocationDot, title: "Trực tuyến"),
  BottomItemModel(
      iconAsset: FontAwesomeIcons.truckMonster, title: "Toàn bộ lộ trình"),
  BottomItemModel(
      iconAsset: FontAwesomeIcons.globe, title: "Theo dõi lộ trình"),
];

class BottomNavBar extends GetView<InspectDetailController> {
  final double spaceHeight = 3; // space between icon and label in bottom navbar
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.realtimeOnly.value
        ? SizedBox.shrink()
        : Container(
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 15)
            ]),
            child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedFontSize: 12,
                currentIndex: controller.currentPage.value,
                type: BottomNavigationBarType.fixed,
                items: List.generate(listItems.length, (index) {
                  return BottomNavigationBarItem(
                    tooltip: listItems[index].title,
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: spaceHeight),
                      child: Icon(
                        listItems[index].iconAsset,
                        size: 22,
                        color: Colors.blueGrey[300],
                      ),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(bottom: spaceHeight),
                      child: Icon(
                        listItems[index].iconAsset,
                        size: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    label: listItems[index].title,
                  );
                }),
                onTap: (index) {
                  controller.setCurrentPage(index);
                })));
  }
}

class BottomItemModel {
  BottomItemModel({required this.iconAsset, required this.title});
  IconData iconAsset;
  String title;
}
