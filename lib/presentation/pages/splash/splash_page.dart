import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/auth/auth_controller.dart';
import 'package:iboxnav/core/utils/shared_pref.dart';
import 'package:iboxnav/core/utils/utility.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static String getName() => "/SplashScreen";

  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final AuthController _auth = Get.find();
  void splashInit() async {
    String? authToken = await SharedPref.getItem(AUTH_TOKEN);
    if (authToken == null || authToken.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));

      Get.offAllNamed("/login");
    } else {
      try {
        await _auth.loginWithBasicToken(authToken, true,
            timeout: const Duration(seconds: 10));
        if (_auth.isLoggedIn.value) {
          Get.offAllNamed("/homepage");
        }
      } catch (e) {
        Get.offAllNamed("/login");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashInit();
    });
  }

  Widget _splash() {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/splash_bg.png"),
              fit: BoxFit.cover,
              opacity: 0.2)),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/iboxnav_logo.png",
              width: 160,
              height: 41,
            ),
          )),
          Positioned.fill(
            bottom: 35,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 258,
                child: Text(
                  "Vietnam Hight - Technology Software Company (VHCSoft)",
                  maxLines: null,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Utility.getFromHex("#BFC3CB"),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.4),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xab0c234b), body: _splash());
  }
}
