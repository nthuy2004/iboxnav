import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/auth/auth_controller.dart';
import 'package:iboxnav/core/utils/snackbar.dart';
import 'package:iboxnav/presentation/components/backdrop.dart';
import 'package:iboxnav/presentation/components/labeled_checkbox.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _auth = Get.find();
  final txtUsernameController = TextEditingController();
  final txtPasswordController = TextEditingController();
  bool isRemeberPassword = true;

  void onLogin() async {

    if (txtUsernameController.text.isEmpty ||
        txtPasswordController.text.isEmpty) {
      GetSnackbarEx.error(message: "Vui lòng nhập đầy đủ thông tin !");
      return;
    }
    context.loaderOverlay.show();
        await Future.delayed(Duration(seconds: 2));
    await _auth.login(txtUsernameController.text, txtPasswordController.text,
        remember: isRemeberPassword);
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 75),
                    child: Image.asset("assets/images/auth_top_picture.png"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 65, left: 30),
                    child: SvgPicture.asset(
                        "assets/images/iboxnav_modern_logo.svg"),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 9),
                        )
                      ]),
                  child: Container(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: ListView(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Đăng nhập để tiếp tục',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.blueGrey[900],
                                fontSize: 26,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: _TextInputField(
                            controller: txtUsernameController,
                            helper: 'Tên đăng nhập',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: _TextInputField(
                            controller: txtPasswordController,
                            helper: 'Mật khẩu',
                            isObscureText: true,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        LabeledCheckbox(
                          label: 'Lưu mật khẩu',
                          value: isRemeberPassword,
                          onChanged: (value) {
                            isRemeberPassword = !isRemeberPassword;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
                              onLogin();
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ))),
                            child: const Text('Đăng nhập'),
                          ),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        SizedBox(
                          height: 40,
                          width: 169,
                          child: Image.asset("assets/images/vhcsoft_logo.png"),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class _TextInputField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  String helper;
  bool isObscureText;
  _TextInputField({
    required this.controller,
    this.hintText = "",
    required this.helper,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          helper,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.blueGrey[300],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 7),
            child: TextFormField(
              controller: controller,
              obscureText: isObscureText,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.only(bottom: 7),
                hintText: hintText,
                border: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.lightBlueAccent[700]!,
                  width: 1.5,
                )),
              ),
            ))
      ],
    );
  }
}
