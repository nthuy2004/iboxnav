import 'package:flutter/material.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/event_data_model.dart';
import 'package:iboxnav/presentation/components/griditem.dart';

class EventInfo extends StatelessWidget {
  final EventDataModel eventData;
  const EventInfo({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: gridContainer(context, [
        GridContainerItem(key: "Thiết bị", value: eventData.deviceId),
        GridContainerItem(key: "Vận tốc", value: "${eventData.speed} (km/h)"),
        GridContainerItem(
            key: "Quãng đường", value: "${eventData.workedKm} (km)"),
        GridContainerItem(
            key: "LX trong ngày",
            value: Utility.secondToHMS(eventData.workedTime)),
        GridContainerItem(
            key: "LX liên tục",
            value: Utility.secondToHMS(eventData.workingTime)),
        GridContainerItem(key: "Đỗ xe", value: "${eventData.noStop}"),
        GridContainerItem(key: "Quá tốc độ", value: "${eventData.overSpeed}"),
        GridContainerItem(key: "Kinh độ", value: "${eventData.lat}"),
        GridContainerItem(key: "Vĩ độ", value: "${eventData.lng}"),
        GridContainerItem(
            key: "Thời gian",
            value: Utility.readTimestamp(eventData.timestamp)),
        GridContainerItem(key: "Vị trí", value: eventData.address ?? "N/A"),
      ]),
    );
  }
}
