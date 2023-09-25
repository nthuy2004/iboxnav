import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iboxnav/core/utils/utility.dart';

class GetDialogEx {
  static alert(
      {String title = "Thông báo",
      String? message,
      Widget? topSection,
      VoidCallback? onOK}) {
    Get.dialog(_baseDialog(
        title: title,
        message: message,
        topSection: topSection,
        buttons: <GetDialogButton>[
          GetDialogButton(text: "OK", onClick: onOK ?? () => Get.back())
        ]));
  }

  static Future<bool> confirm(
      {String? title, String? message, Widget? topSection}) async {
    bool? result = await Get.dialog<bool>(_baseDialog(
        title: title ?? "Xác nhận",
        message: message,
        topSection: topSection,
        buttons: <GetDialogButton>[
          GetDialogButton(
              text: "Không", onClick: () => Get.back(result: false)),
          GetDialogButton(text: "Có", onClick: () => Get.back(result: true)),
        ]));
    return result ?? false;
  }

  static custom(
      {String? title,
      String? message,
      Widget? topSection,
      List<GetDialogButton>? buttons}) {
    Get.dialog(_baseDialog(
        title: title,
        message: message,
        topSection: topSection,
        buttons: buttons));
  }

  static Widget _baseDialog(
      {String? title,
      String? message,
      Widget? topSection,
      List<GetDialogButton>? buttons}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utility.renderIfTrue(
                    topSection != null,
                    child: topSection ?? const SizedBox.shrink(),
                  ),
                  Utility.renderIfTrue(title != null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 8),
                        child: Text(title ?? "",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700)),
                      )),
                  Utility.renderIfTrue(message != null,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(message ?? "",
                            style: const TextStyle(fontSize: 15)),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (GetDialogButton btn in buttons!) btn.toWidget()
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GetDialogButton {
  String text;
  Color? color;
  VoidCallback? onClick;
  GetDialogButton({required this.text, this.color, this.onClick});
  Widget toWidget() {
    return TextButton(
        onPressed: onClick ?? () => Get.back(),
        child: Text(
          text,
          style: TextStyle(fontSize: 15, color: color),
        ));
  }
}
