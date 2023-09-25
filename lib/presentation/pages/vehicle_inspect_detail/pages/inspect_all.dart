import 'dart:async';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iboxnav/config/colors.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_all_controller.dart';
import 'package:iboxnav/core/utils/dialog.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/presentation/pages/vehicle_inspect_detail/widgets/event_info_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class InspectAll extends StatefulWidget {
  const InspectAll({super.key});

  @override
  State<InspectAll> createState() => _InspectAllState();
}

class _InspectAllState extends State<InspectAll> {
  final Completer<GoogleMapController> _mapController = Completer();
  final InspectAllController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await init();
    });
  }

  Future init() async {
    GoogleMapController controller = await _mapController.future;
    try {
      _controller.controller.showLoading(context);
      await _controller.initData();
      controller.moveCamera(
          CameraUpdate.newLatLng(_controller.eventModels.first.getPos()));
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

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Set<Marker> get getMarkers {
    Set<Marker> res = {};
    int eventLength = _controller.eventModels.length;
    BitmapDescriptor getMarker(int i) {
      if (i == 0) return _controller.controller.startIcon;
      if (i == eventLength - 1) return _controller.controller.vehicleIcon;
      if (i != 0 && i % 4 == 0)
        return _controller.controller.flagIcon;
      else
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
    }

    double bearing(int i) {
      if (i == eventLength - 1 && eventLength > 2) {
        return Utility.calculateBearing(
            _controller.eventModels.elementAt(i - 1).getPos(),
            _controller.eventModels.elementAt(i).getPos());
      }
      return -1;
    }

    for (final (i, v) in _controller.eventModels.indexed) {
      res.addIf(
          i % 4 == 0 || i == eventLength - 1,
          Marker(
            markerId: MarkerId("${v.timestamp}"),
            position: v.getPos(),
            icon: getMarker(i),
            rotation: bearing(i),
            flat: true,
            onTap: () async {
              await _controller.getEventData(v.timestamp);
            },
          ));
    }

    return res;
  }

  Widget _body() {
    return BottomSheetBar(
        height: 75,
        controller: _controller.bottomSheetController,
        locked: false,
        isDismissable: false,
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
        expandedBuilder: (_) => Obx(() => _bottomSheet()),
        collapsed: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: _topInfo(),
        ),
        body: Obx(() => GoogleMap(
              polylines: {
                Polyline(
                  polylineId: PolylineId(_controller.controller.vehicleId),
                  points: _controller.eventModels
                      .map((element) => element.getPos())
                      .toList(),
                  color: POLYLINE_COLOR,
                  width: 3,
                )
              },
              markers: getMarkers,
              initialCameraPosition:
                  _controller.controller.initialCameraPosition,
              onMapCreated: (controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                  _mapController.future.then((value) =>
                      value.setMapStyle(_controller.controller.mapStyle));
                }

                context.loaderOverlay.hide();
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

  Row _topInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        )
      ],
    );
  }
}
