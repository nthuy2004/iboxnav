import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final bool allowBack;
  final EdgeInsets padding;
  BoxDecoration? decoration;
  CustomAppbar(
      {super.key,
      required this.title,
      this.allowBack = true,
      this.padding = EdgeInsets.zero,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            allowBack
                ? Material(
                    type: MaterialType.transparency,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey[300]!,
                                offset: const Offset(
                                  2.0,
                                  2.0,
                                ),
                                blurRadius: 10.0,
                                spreadRadius: 2),
                          ],
                          borderRadius:
                              BorderRadius.circular(15.0)), //<-- SEE HERE
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100.0),
                        onTap: () {
                          Get.back();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            size: 30.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                title,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
