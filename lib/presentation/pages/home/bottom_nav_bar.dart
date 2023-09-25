import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/home/home_controller.dart';

List<BottomItemModel> listItems = [
  BottomItemModel(
      iconAsset: "assets/images/bottom_icon_car_list.svg",
      title: "Danh sách xe"),
  BottomItemModel(
      iconAsset: "assets/images/bottom_icon_map.svg", title: "Giám sát"),
  BottomItemModel(
      iconAsset: "assets/images/bottom_icon_statistic.svg", title: "Thống kê"),
  BottomItemModel(
      iconAsset: "assets/images/bottom_icon_utils.svg", title: "Tiện ích"),
];

class BottomNavBar extends StatelessWidget {
  final HomeController _homeController = Get.find();
  final double SPACE_BETWEEN_LABEL_AND_ICON = 3;
  BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 15)
            ]),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedFontSize: 12,
          currentIndex: _homeController.currentPage.value,
          type: BottomNavigationBarType.fixed,
          items: List.generate(listItems.length, (index) {
            return BottomNavigationBarItem(
              tooltip: listItems[index].title,
              icon: Padding(
                padding: EdgeInsets.only(bottom: SPACE_BETWEEN_LABEL_AND_ICON),
                child: SvgPicture.asset(
                  listItems[index].iconAsset,
                  width: 24,
                  height: 24,
                  color: Colors.blueGrey[300],
                ),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: SPACE_BETWEEN_LABEL_AND_ICON),
                child: SvgPicture.asset(
                  listItems[index].iconAsset,
                  width: 24,
                  height: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              label: listItems[index].title,
            );
          }),
          onTap: (index) {
            _homeController.goToPage(index);
          },
        )));
  }
}

class BottomItemModel {
  BottomItemModel({required this.iconAsset, required this.title});
  String iconAsset;
  String title;
}
