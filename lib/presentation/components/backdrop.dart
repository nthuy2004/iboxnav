import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Backdrop {
  static Backdrop? _instance;
  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  Backdrop._createInstance();

  factory Backdrop() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = Backdrop._createInstance();
      return _instance!;
    }
  }

  show(context) {
    _overlayState = Overlay.of(context);
    _build();
    _overlayState!.insert(_overlayEntry!);
  }

  hide() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      print("Exception:: $e");
    }
  }

  _build() {
    _overlayEntry = OverlayEntry(builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: const Color(0x212529).withOpacity(0.5),
          child: const Align(
            alignment: Alignment.center,
            child: SpinKitRing(
              color: Colors.white,
              size: 60.0,
              lineWidth: 4.0,
            ),
          ),
        ),
      );
    });
  }
}
