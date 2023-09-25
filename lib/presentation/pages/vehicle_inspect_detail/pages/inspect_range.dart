import 'dart:async';

import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iboxnav/config/colors.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_range_controller.dart';
import 'package:iboxnav/core/utils/snackbar.dart';
import 'package:iboxnav/models/event_data_model.dart';
import 'package:iboxnav/presentation/components/error_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/event_info_widget.dart';

class InspectRange extends StatefulWidget {
  const InspectRange({super.key});

  @override
  State<InspectRange> createState() => _InspectRangeState();
}

class _InspectRangeState extends State<InspectRange> {
  final InspectRangeController _controller = Get.find();
  final Completer<GoogleMapController> _mapController = Completer();

  Future init() async {
    _controller.controller.showLoading(context);
    await _controller.initData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.stopStream();
  }

  Set<Marker> get getMarkers {
    Set<Marker> res = {};
    int eventLength = _controller.eventModels.length;
    BitmapDescriptor getMarker(int i) {
      if (i == 0) return _controller.controller.startIcon;
      if (i == eventLength - 1) return _controller.controller.endIcon;
      if (i != 0 && i % 4 == 0)
        return _controller.controller.flagIcon;
      else
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
    }

    for (final (i, v) in _controller.eventModels.indexed) {
      res.addIf(
          i % 4 == 0 || i == eventLength - 1,
          Marker(
            markerId: MarkerId("${v.timestamp}"),
            position: v.getPos(),
            icon: getMarker(i),
            rotation: -1,
            flat: true,
            onTap: () async {
              await _controller.getEventData(v.timestamp);
            },
          ));
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              _controller.controller.hideLoading(context);
              return ErrorWidget2(
                text: "Không có thông tin hành trình",
                btnText: "Quay lại",
                callback: () => Get.back(),
              );
            } else {
              return _body();
            }
          }
          return Container();
        });
  }

  Widget _body() {
    return Obx(() {
      return BottomSheetBar(
          controller: _controller.bottomSheetController,
          height: 137,
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
          collapsed: _bottom(),
          body: Animarker(
              onStopover: (latLng) async {
                final GoogleMapController controller =
                    await _mapController.future;
                try {
                  await controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: latLng,
                          zoom: _controller.currentCameraZoom.value)));
                } catch (e) {}
              },
              shouldAnimateCamera: false,
              zoom: _controller.currentCameraZoom.value,
              duration: _controller.currentDuration.value,
              mapId: _mapController.future.then<int>((value) => value.mapId),
              markers: {
                Marker(
                    markerId: const MarkerId("vehicleMarker"),
                    position: _controller.vehiclePos.value,
                    flat: true,
                    icon: _controller.controller.vehicleIcon)
              },
              child: GoogleMap(
                markers: getMarkers,
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('polyline'),
                    points: _controller.eventModels
                        .map((element) => element.getPos())
                        .toList(),
                    color: POLYLINE_COLOR,
                    width: 4,
                  )
                },
                initialCameraPosition: _controller.cameraPos,
                onCameraMove: (position) {
                  _controller.currentCameraZoom.value = position.zoom;
                },
                onMapCreated: (controller) {
                  if (!_mapController.isCompleted) {
                    _mapController.complete(controller);
                    _mapController.future.then((value) =>
                        value.setMapStyle(_controller.controller.mapStyle));
                  }
                  _controller.controller.hideLoading(context);
                },
              )),
          expandedBuilder: (_) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bottom(),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: EventInfo(
                        eventData: _controller.eventData.value,
                      ))
                ],
              ));
    });
  }

  Widget _bottom() {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _controller.toggleStream();
                            },
                            icon: Icon(
                                _controller.state.value == PlayingState.Playing
                                    ? FontAwesomeIcons.pause
                                    : FontAwesomeIcons.play)),
                        const SizedBox(
                          width: 8,
                        ),
                        IconButton(
                            onPressed: () {
                              _mapController.future.then((value) {
                                value.moveCamera(CameraUpdate.newLatLng(
                                    _controller.eventModels.first.getPos()));
                              });
                              _controller.stopStream();
                            },
                            icon: const Icon(FontAwesomeIcons.stop)),
                        const SizedBox(
                          width: 8,
                        ),
                        IconButton(
                            onPressed: () {
                              _showBottomSheet(context);
                            },
                            icon: const Icon(FontAwesomeIcons.gauge))
                      ],
                    )
                  ],
                ),
                Slider(
                  min: 0.0,
                  max: 100.0,
                  value: ((_controller.counter /
                          _controller.processedEvents.length) *
                      100),
                  onChanged: (value) {},
                )
              ],
            ),
          )),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.2,
                maxChildSize: 0.75,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child: ListView.builder(
                      controller: controller,
                      itemCount: _controller.speed.length,
                      itemBuilder: (_, index) {
                        double value = _controller.speed.keys.elementAt(index);
                        return ListTile(
                          leading: value == _controller.currentSpeed
                              ? const Icon(FontAwesomeIcons.check)
                              : const Icon(null),
                          title: Text('${value}x'),
                          onTap: () {
                            Navigator.of(context).pop(); // close BottomSheet
                            GetSnackbarEx.success(
                                message: "Đã chỉnh tốc độ ở mức: ${value}x");
                            _controller.onSpeedChange(
                                _controller.speed.keys.elementAt(index));
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
