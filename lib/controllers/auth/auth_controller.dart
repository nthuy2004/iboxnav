import 'dart:convert';
import 'package:get/get.dart';
import 'package:iboxnav/core/exceptions/exceptions.dart';
import 'package:iboxnav/core/extensions/extensions.dart';
import 'package:iboxnav/core/network/api_service.dart';
import 'package:iboxnav/core/utils/dialog.dart';
import 'package:iboxnav/core/utils/shared_pref.dart';
import 'package:iboxnav/core/utils/snackbar.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart' as dio;

class AuthController extends GetxController {
  final ApiService _apiService = Get.find();
  var isLoggedIn = false.obs;
  var userInfo = UserModel().obs;
  var authorization = Authorization().obs;
  setUserInfo(UserModel model) {
    userInfo.value = model;
  }

  setAuth(Authorization auth) {
    authorization.value = auth;
  }

  Authorization getAuth() {
    return authorization.value;
  }

  setLoggedIn(bool state) {
    isLoggedIn.value = state;
  }

  login(String username, String password, {bool remember = false}) async {
    //await Future.delayed(Duration(seconds: 2));
    try {
      String token = Utility.getBasicToken(username, password);
      await loginWithBasicToken(token, remember,
          timeout: const Duration(seconds: 10));
      if (isLoggedIn.isTrue) {
        GetSnackbarEx.success(message: "Xin chào ${userInfo.value.fullname}");
        Get.offAllNamed("/homepage");
      }
    } on AuthorizationException {
      GetSnackbarEx.error(
          message: "Sai thông tin đăng nhập !",
          icon: FontAwesomeIcons.fingerprint);
    } on ConnectionTimeoutException {
      GetDialogEx.alert(
          title: "Error",
          message:
              "Có thể do mạng yếu hoặc chưa kết nối internet. Bạn hãy kiểm tra và thử lại nhé !",
          onOK: () {
            Get.back();
          });
    } catch (e) {
      GetDialogEx.alert(
          title: "Error",
          message: "Lỗi không xác định, vui lòng thử lại sau !",
          onOK: () {
            Get.back();
          });
    }
  }

  loginWithBasicToken(String basicToken, bool remember,
      {Duration? timeout}) async {
    Authorization auth =
        Authorization(authType: AuthorizationType.Basic, token: basicToken);
    dio.Response response = await _apiService.get("/v1.0/user/auth",
        authorization: auth, timeout: timeout);
    if (response.isOK()) {
      if (remember) {
        await SharedPref.setItem(AUTH_TOKEN, basicToken);
      }
      setLoggedIn(true);
      setAuth(auth);
      setUserInfo(UserModel.fromJson(json.decode(response.data)));
    }
  }

  logout() async {
    setLoggedIn(false);
    setAuth(Authorization.none());
    await SharedPref.deleteItem(AUTH_TOKEN);
    GetSnackbarEx.success(message: "Đăng xuất thành công!");
    Get.offAllNamed("/login");
  }
}
