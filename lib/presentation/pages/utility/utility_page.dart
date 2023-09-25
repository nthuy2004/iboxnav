import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/auth/auth_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboxnav/core/utils/dialog.dart';
import 'package:iboxnav/presentation/components/tile.dart';

class UtilityPage extends GetView<AuthController> {
  const UtilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [topProfile(context)],
        ),
      )),
    );
  }

  void onLogout() async {
    bool result = await GetDialogEx.confirm(
        message: "Đăng xuất khỏi tài khoản của bạn ?");
    if (result) {
      await controller.logout();
    }
  }

  Widget topProfile(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xffE6E6E6),
                radius: 45,
                child: Icon(
                  Icons.person,
                  color: Color(0xffCCCCCC),
                  size: 50,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                controller.userInfo.value.fullname!,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Tile.Header(context, "Báo cáo"),
                      Tile.Item(context,
                          text: "Báo cáo tài khoản",
                          icon: FontAwesomeIcons.userClock, onClick: () {
                        GetDialogEx.alert(
                            message: "Không có thông tin báo cáo !");
                      }),
                      Tile.Item(context,
                          text: "Báo cáo mất tín hiêu vệ tinh",
                          icon: FontAwesomeIcons.satelliteDish, onClick: () {
                        GetDialogEx.alert(
                            message: "Không có thông tin báo cáo !");
                      }),
                      Tile.Header(context, "Tiện ích"),
                      Tile.Item(context,
                          text: "Liên hệ",
                          icon: FontAwesomeIcons.headset,
                          onClick: () => Get.toNamed("/contact")),
                      Tile.Item(context,
                          text: "Đăng xuất",
                          icon: FontAwesomeIcons.arrowRightFromBracket,
                          onClick: onLogout),
                    ],
                  ))
            ],
          )),
    );
  }
}
