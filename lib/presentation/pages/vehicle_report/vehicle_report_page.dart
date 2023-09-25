import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iboxnav/config/constants.dart';
import 'package:iboxnav/controllers/vehicle/vehicle_controller.dart';
import 'package:iboxnav/controllers/widget/combobox_controller.dart';
import 'package:iboxnav/controllers/widget/datetime_controller.dart';
import 'package:iboxnav/core/utils/dialog.dart';
import 'package:iboxnav/core/utils/snackbar.dart';
import 'package:iboxnav/presentation/components/combo_box.dart';
import 'package:iboxnav/presentation/components/datetime_picker.dart';
import 'package:iboxnav/presentation/components/tile.dart';

class VehicleReportPage extends StatelessWidget {
  const VehicleReportPage({super.key});

  String getReportUrlByIndex(int index) {
    return Constants.INSPECT_TYPES.keys.elementAt(index);
  }

  void onClick(index) {
    Get.toNamed("/reportdetail/${getReportUrlByIndex(index)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Thống kê xe",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  )),
            ),
            Tile.Header(context, "Báo cáo"),
            ...List.generate(Constants.INSPECT_TYPES.length, (index) {
              var a = Constants.INSPECT_TYPES.values.elementAt(index);
              return Tile.Item(context,
                  text: a.title, icon: a.icon, onClick: () => onClick(index));
            })
          ],
        ),
      )),
    );
  }
}
