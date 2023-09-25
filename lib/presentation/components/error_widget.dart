import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class ErrorWidget2 extends StatelessWidget {
  String? text;
  VoidCallback? callback;
  String? btnText;
  Widget? topChild;
  ErrorWidget2(
      {super.key, this.text, this.callback, this.btnText, this.topChild});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          topChild != null
              ? topChild!
              : const Icon(
                  FontAwesomeIcons.circleExclamation,
                  size: 50.0,
                  color: Colors.black,
                ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text == null ? "UNKNOWN ERROR" : text!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ),
          btnText != null
              ? TextButton(onPressed: callback, child: Text(btnText!))
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
