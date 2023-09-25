import 'package:flutter/material.dart';
import 'package:iboxnav/core/extensions/extensions.dart';
import 'package:iboxnav/presentation/components/appbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          CustomAppbar(
            title: "Liên hệ",
            padding: const EdgeInsets.all(20),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.h, bottom: 3.h),
                        child: Image.asset(
                          "assets/images/vhcsoft_logo.png",
                          width: 50.w,
                        ),
                      ),
                      Text(
                        "Công ty CP Phần Mềm Công Nghệ Cao Việt Nam",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.lightBlue[700]),
                      ),
                      const Text(
                        "Địa chỉ: 7/146, Quan Thổ 1, Tôn Đức Thắng, Quận Đống Đa, T.P Hà Nội",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14),
                      ),
                      _info(
                          label: "Website:",
                          content: "http://www.vhc.com.vn",
                          type: UriType.url),
                      _info(
                          label: "Email:",
                          content: "support@vhc.com.vn",
                          type: UriType.email),
                      _info(
                          label: "Số điện thoại:",
                          content: "0963 901 403",
                          type: UriType.tel)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  String getUri(UriType type, String content) {
    switch (type) {
      case UriType.tel:
        return "tel:${content.superTrim()}";
      case UriType.email:
        return "mailto:$content";
      default:
        return content;
    }
  }

  Widget _info(
      {required String label, required String content, required UriType type}) {
    void onTap() async {
      try {
        await launchUrlString(getUri(type, content));
      } catch (e) {}
    }

    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: Text(label)),
          Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: onTap,
                child: Text(content,
                    style: TextStyle(
                      color: Colors.lightBlue[700],
                      decoration: TextDecoration.underline,
                    )),
              ))
        ],
      ),
    );
  }
}

enum UriType { url, tel, email }
