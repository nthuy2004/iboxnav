import 'dart:async';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iboxnav/config/colors.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/realtime_inspect_controller.dart';
import 'package:iboxnav/core/utils/dialog.dart';
import 'package:iboxnav/core/utils/map_utility.dart';
import 'package:iboxnav/core/utils/snackbar.dart';
import 'package:iboxnav/presentation/pages/vehicle_inspect_detail/widgets/event_info_widget.dart';

class RealtimeInspect extends StatefulWidget {
  const RealtimeInspect({super.key});

  @override
  State<RealtimeInspect> createState() => RealtimeInspectState();
}

class RealtimeInspectState extends State<RealtimeInspect> {
  double currentCameraZoom = 14;
  Timer? interval;
  final Completer<GoogleMapController> _mapController = Completer();
  final RealtimeInspectController _controller = Get.find();
  @override
  void dispose() {
    if (interval != null) {
      interval!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.controller.showLoading(context);
    _controller.clearData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await init();
    });
  }

  Future init() async {
    try {
      final GoogleMapController controller = await _mapController.future;
      await _controller.initData();
      controller
          .moveCamera(CameraUpdate.newLatLng(_controller.lastModel!.getPos()));
      interval ??= Timer.periodic(const Duration(seconds: 15), (timer) async {
        try {
          await _controller.getNextEventData();
          await goto(_controller.lastModel!.getPos());
        } catch (e) {
          GetSnackbarEx.error(message: "Không thể nhận thông tin !");
        }
      });
    } catch (e) {
      GetDialogEx.custom(
          title: "Lỗi",
          message: "Không lấy được thông tin xe, bạn có muốn thử lại không ?",
          buttons: <GetDialogButton>[
            GetDialogButton(text: "Không"),
            GetDialogButton(
                text: "Thử lại",
                onClick: () async {
                  Get.back();
                  await init();
                }),
          ]);
    } finally {
      _controller.controller.hideLoading(context);
    }
  }

  Future<void> goto(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    try {
      await controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: pos, zoom: currentCameraZoom)));
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _body());
  }

  Set<Marker> get getMarkers {
    Set<Marker> res = {};
    int eventLength = _controller.eventModels.length;
    getMarker(int i) {
      if (i == eventLength - 1) return _controller.controller.vehicleIcon;
      if (i == 0) return _controller.controller.startIcon;
      return _controller.controller.flagIcon;
    }

    double getRotation(int i) {
      if (i == 0 || i != eventLength - 1) return -1;
      LatLng first = _controller.eventModels.elementAt(i - 1).getPos();
      LatLng second = _controller.eventModels.elementAt(i).getPos();
      return getBearing(first, second);
    }

    for (final (i, v) in _controller.eventModels.indexed) {
      res.add(Marker(
        markerId: MarkerId("$i"),
        position: v.getPos(),
        icon: getMarker(i),
        flat: true,
        rotation: getRotation(i),
        onTap: () async {
          _controller.eventData.value = v;
          _controller.bottomSheetController.expand();
        },
      ));
    }

    return res;
  }

  Widget _body() {
    return BottomSheetBar(
        controller: _controller.bottomSheetController,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        borderRadiusExpanded: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5.0,
            blurRadius: 32.0,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        isDismissable: false,
        locked: false,
        height: 75,
        collapsed: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: _topInfo()),
        expandedBuilder: (_) => Obx(() => _bottomSheet()),
        body: Obx(() => GoogleMap(
              markers: Set.of(getMarkers),
              polylines: {
                Polyline(
                  polylineId: PolylineId(_controller.controller.vehicleId),
                  patterns: <PatternItem>[
                    PatternItem.dash(50.0),
                    PatternItem.gap(20.0)
                  ],
                  points: _controller.eventModels
                      .map((element) => element.getPos())
                      .toList(),
                  color: POLYLINE_COLOR,
                  width: 4,
                )
              },
              initialCameraPosition: _controller.initialCameraPosition,
              onCameraMove: (cam) {
                currentCameraZoom = cam.zoom;
              },
              onMapCreated: (controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                  _mapController.future.then((value) =>
                      value.setMapStyle(_controller.controller.mapStyle));
                }
              },
              //markers: getMarkers(_controller.controller.markers.value.values),
            )));
  }

  Widget _bottomSheet() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topInfo(),
          const SizedBox(
            height: 14,
          ),
          Container(
              child: EventInfo(
            eventData: _controller.eventData.value,
          ))
        ],
      ),
    );
  }

  Widget _topInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Biển số xe:",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey[300]!),
            ),
            Text(
              _controller.controller.vehicleId,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            )
          ],
        ),
        Text("Vận tốc: ${_controller.eventData.value.speed}km/h")
      ],
    );
  }
}
