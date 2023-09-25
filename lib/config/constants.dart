import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Constants {
  static const API_BASE_URL = "http://iboxnav.com.vn:8000/api";
  static const DATETIME_FORMAT = "dd/MM/yyyy HH:mm:dd";
  static const Map<String, ReportType> INSPECT_TYPES = {
    "parking": ReportType(
        title: "Báo cáo dừng đỗ", icon: FontAwesomeIcons.squareParking),
    "work":
        ReportType(title: "Báo cáo làm việc", icon: FontAwesomeIcons.briefcase),
    "overspeed":
        ReportType(title: "Báo cáo quá tốc độ", icon: FontAwesomeIcons.ban),
    "workdetail": ReportType(
        title: "Báo cáo thời gian lái xe liên tục",
        icon: FontAwesomeIcons.gaugeHigh),
    "door":
        ReportType(title: "Báo cáo đóng mở", icon: FontAwesomeIcons.doorOpen)
  };
}

class ReportType {
  final String title;
  final IconData icon;
  const ReportType({required this.title, required this.icon});
}
enum FutureState {
  Loading,
  HasData,
  HasError,
  Idle,
}
