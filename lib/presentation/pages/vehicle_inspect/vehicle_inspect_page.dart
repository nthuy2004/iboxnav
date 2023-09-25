import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/vehicle/vehicle_controller.dart';
import 'package:iboxnav/controllers/widget/combobox_controller.dart';
import 'package:iboxnav/controllers/widget/datetime_controller.dart';
import 'package:iboxnav/core/utils/snackbar.dart';
import 'package:iboxnav/presentation/components/combo_box.dart';
import 'package:iboxnav/presentation/components/datetime_picker.dart';

class CarInspectPage extends StatefulWidget {
  const CarInspectPage({super.key});

  @override
  State<CarInspectPage> createState() => _CarInspectPageState();
}

class _CarInspectPageState extends State<CarInspectPage> {
  final _vehicle = Get.find<VehicleController>();
  final DatetimePickerController _startDate = DatetimePickerController(
      date: DateTime.now().subtract(const Duration(hours: 6)));
  final DatetimePickerController _endDate =
      DatetimePickerController(date: DateTime.now());
  ComboboxController<String>? _vehiclesID;

  @override
  void initState() {
    List<String> items =
        _vehicle.vehicles.map((vehicle) => vehicle.vehicleId).toList();
    _vehiclesID = ComboboxController(list: items);
    super.initState();
  }

  @override
  void dispose() {
    _startDate.dispose();
    _endDate.dispose();
    super.dispose();
  }

  void onContinue() {
    if (_startDate.compareTo(_endDate) >= 0) {
      GetSnackbarEx.error(
          message: "Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc !",
          icon: FontAwesomeIcons.clock);
      return;
    }
    Get.toNamed("/inspectdetail",
        arguments: [_vehiclesID!.value, _startDate.date, _endDate.date]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 10),
                child:
                    Image.asset("assets/images/img_vehicle_inspect_top.png")),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                "Chọn biển số xe bạn muốn theo dõi",
                maxLines: null,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey[900],
                    fontSize: 30,
                    height: 1.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Combobox(
                    controller: _vehiclesID!,
                    showHintOnly: true,
                    helper: "Chọn biển số xe",
                  ),
                  DatetimePicker(
                    controller: _startDate,
                    helper: "Ngày bắt đầu",
                  ),
                  DatetimePicker(
                    controller: _endDate,
                    helper: "Ngày kết thúc",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Container(
                        height: 56,
                        width: double.maxFinite,
                        child: ElevatedButton(
                            onPressed: onContinue,
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ))),
                            child: Text("Tiếp tục"))),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
