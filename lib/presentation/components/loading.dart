import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iboxnav/core/utils/dialog.dart';

// ignore: must_be_immutable
class LoadingWidget extends StatelessWidget {
  String? text;
  Widget? child;
  final bool confirmOnBack;
  final bool withRectangle;
  LoadingWidget(
      {super.key,
      this.text,
      this.child,
      this.confirmOnBack = false,
      this.withRectangle = false});

  @override
  Widget build(BuildContext context) {
    if (confirmOnBack) {
      return WillPopScope(
          child: _body(context),
          onWillPop: () async {
            return await GetDialogEx.confirm(
                title: "Xác nhận!", message: "Bạn có muốn huỷ tiến trình ?");
          });
    } else {
      return withRectangle ? _withRectangle(context) : _body(context);
    }
  }

  Widget _body(context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child != null
            ? child!
            : SpinKitRing(
                color: Theme.of(context).primaryColor,
                size: 50.0,
                lineWidth: 4.0,
              ),
        const SizedBox(
          height: 24,
        ),
        Text(
          text!,
          style:
              const TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
        )
      ],
    ));
  }

  Widget _withRectangle(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Center(
              child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: _body(context),
          )),
        ],
      ),
    );
  }
}
