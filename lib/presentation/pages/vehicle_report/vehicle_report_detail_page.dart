import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iboxnav/config/constants.dart';
import 'package:iboxnav/controllers/vehicle/vehicle_controller.dart';
import 'package:iboxnav/controllers/widget/combobox_controller.dart';
import 'package:iboxnav/controllers/widget/datetime_controller.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/report_model/detail_work_report_model.dart';
import 'package:iboxnav/models/report_model/overspeed_report_model.dart';
import 'package:iboxnav/models/report_model/parking_report_model.dart';
import 'package:iboxnav/models/report_model/work_report_model.dart';
import 'package:iboxnav/presentation/components/appbar.dart';
import 'package:iboxnav/presentation/components/combo_box.dart';
import 'package:iboxnav/presentation/components/contest_tab_header.dart';
import 'package:iboxnav/presentation/components/datetime_picker.dart';
import 'package:iboxnav/presentation/components/error_widget.dart';
import 'package:iboxnav/repositories/report_repository.dart';

import 'page.dart';

class VehicleReportDetailPage<T> extends StatefulWidget {
  VehicleReportDetailPage({super.key});

  @override
  State<VehicleReportDetailPage> createState() =>
      _VehicleReportDetailPageState();
}

class _VehicleReportDetailPageState extends State<VehicleReportDetailPage> {
  final VehicleController _vehicle = Get.find();

  final ReportRepository _report = Get.put(ReportRepository());

  final String? reportType = Get.parameters["report"];

  @override
  Widget build(BuildContext context) {
    return _reportWidget();
  }

  Widget _reportWidget() {
    switch (reportType) {
      case "parking":
        return _parkingWidget();
      case "work":
        return _workWidget();
      case "overspeed":
        return _overspeedWidget();
      case "workdetail":
        return _workdetailWidget();
      case "door":
        return _doorWidget();
      default:
        return _unknown();
    }
  }

  Widget _parkingWidget() {
    return BaseReportPage<ParkingReportModel>(
        reportType: "parking",
        thead: [
          TableHead(name: "Lái xe", size: ColumnSize.L),
          TableHead(name: "Bắt đầu", size: ColumnSize.M),
          TableHead(name: "Kết thúc", size: ColumnSize.M),
          TableHead(name: "Trạng thái", size: ColumnSize.S),
          TableHead(name: "Lần đỗ xe", size: ColumnSize.S),
        ],
        rowBuilder: (context, data) => DataRow(cells: [
              DataCell(Text('${data.driverName}',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(Utility.readTimestamp(data.startTime))),
              DataCell(Text(Utility.readTimestamp(data.endTime))),
              DataCell(Text(data.isStop == 1 ? "Đỗ" : "Dừng")),
              DataCell(Text('${data.noStop}'))
            ]));
  }

  Widget _workWidget() {
    return BaseReportPage<WorkReportModel>(
        reportType: "work",
        thead: [
          TableHead(name: "Lái xe", size: ColumnSize.L),
          TableHead(name: "Bắt đầu", size: ColumnSize.M),
          TableHead(name: "Kết thúc", size: ColumnSize.M),
          TableHead(name: "Số KM", size: ColumnSize.S),
          TableHead(name: "Thời gian", size: ColumnSize.M),
        ],
        rowBuilder: (context, data) => DataRow(cells: [
              DataCell(Text('${data.driverName}',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(Utility.readTimestamp(data.startTime))),
              DataCell(Text(Utility.readTimestamp(data.endTime))),
              DataCell(Text('${data.km}')),
              DataCell(Text(Utility.secondToHMS(data.time)))
            ]));
  }

  Widget _overspeedWidget() {
    return BaseReportPage<OverspeedReportModel>(
        reportType: "overspeed",
        thead: [
          TableHead(name: "Lái xe", size: ColumnSize.L),
          TableHead(name: "Bắt đầu", size: ColumnSize.M),
          TableHead(name: "TG quá tốc", size: ColumnSize.M),
          TableHead(name: "Vận tốc", size: ColumnSize.M),
        ],
        rowBuilder: (context, data) => DataRow(cells: [
              DataCell(Text('${data.driverName}',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(Utility.readTimestamp(data.startTime))),
              DataCell(
                  Text(Utility.secondToHMS(data.endTime - data.startTime))),
              DataCell(Text("${data.maxSpeed} / ${data.limitSpeed}")),
            ]));
  }

  Widget _workdetailWidget() {
    return BaseReportPage<DetailWorkReportModel>(
        reportType: "workdetail",
        thead: [
          TableHead(name: "Lái xe", size: ColumnSize.L),
          TableHead(name: "Bắt đầu", size: ColumnSize.M),
          TableHead(name: "Kết thúc", size: ColumnSize.M),
          TableHead(name: "Số km", size: ColumnSize.S),
          TableHead(name: "Thời gian", size: ColumnSize.S),
        ],
        rowBuilder: (context, data) => DataRow(cells: [
              DataCell(Text('${data.driverName}',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(Utility.readTimestamp(data.startTime))),
              DataCell(Text(Utility.readTimestamp(data.endTime))),
              DataCell(Text('${data.km}')),
              DataCell(Text(Utility.secondToHMS(data.time)))
            ]));
  }

  Widget _doorWidget() {
    return _unknown();
  }

  Widget _unknown() {
    return Scaffold(body: ErrorWidget2(
        text: "Tính năng không có sẵn",
        btnText: "Quay lại",
        callback: () => Get.back(),
      ),);
  }
}
