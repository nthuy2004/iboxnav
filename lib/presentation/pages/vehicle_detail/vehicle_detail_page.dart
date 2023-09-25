import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/vehicle_detail/vehicle_detail_controller.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/vehicle_model.dart';
import 'package:iboxnav/presentation/components/appbar.dart';
import 'package:iboxnav/presentation/pages/vehicle_detail/vehicle_detail_skeleton.dart';
import 'package:iboxnav/presentation/components/error_widget.dart';

import '../../components/griditem.dart';

class VehicleDetailPage extends GetView<VehicleDetailController> {
  const VehicleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx((state) {
      if (state == null) return const VehicleDetailSkeleton();
      return _build(context, model: state["model"], addr: state["addr"]);
    },
        onLoading: const VehicleDetailSkeleton(),
        onError: (a) => VehicleDetailError(
              e: a,
              cb: () => controller.init(),
            ));
  }

  Widget _build(context, {required VehicleModel model, String? addr}) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTop(model),
          Expanded(
              child: Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(10.0, 10.0),
                      blurRadius: 15.0)
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              gridHeader("Thông tin xe"),
                              gridContainer(context, [
                                GridContainerItem(
                                    key: "Vĩ độ", value: model.lat.toString()),
                                GridContainerItem(
                                    key: "Vận tốc giới hạn",
                                    value: "${model.speedLimit} Km/h"),
                                GridContainerItem(
                                    key: "Kinh độ",
                                    value: model.lng.toString()),
                                GridContainerItem(
                                    key: "Quãng dường",
                                    value: "${model.engineKm} Km"),
                                GridContainerItem(
                                    key: "Vận tốc",
                                    value: "${model.speed} Km/h")
                              ]),
                              gridHeader("Thông tin lái xe"),
                              gridContainer(context, [
                                GridContainerItem(
                                    key: "Lái xe",
                                    value:
                                        model.driverName ?? "Không xác định"),
                                GridContainerItem(
                                    key: "Số điện thoại",
                                    value:
                                        model.phoneNumber ?? "Không xác định"),
                                GridContainerItem(
                                    key: "Giấy phép lái xe",
                                    value: model.driverLicenseNumber ??
                                        "Không xác định")
                              ]),
                              gridHeader("Vị trí hiện tại"),
                              Text(
                                addr ?? "Không xác định",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 58,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed("/inspectdetail", arguments: [
                            model.driverLicenseNumber,
                            null,
                            null
                          ]);
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ))),
                        child: Text('Giám sát xe'.tr),
                      )),
                ],
              ),
            ),
          ))
        ],
      )),
    );
  }

  Widget _buildTop(VehicleModel model) {
    return Container(
      height: 210,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/img_group2.png",
            ),
            fit: BoxFit.contain,
            alignment: Alignment.centerRight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomAppbar(title: "Thông tin xe", padding: EdgeInsets.all(20)),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 10,
            ),
            child: Text(
              model.vehicleId,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 6,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/img_calendar91.svg",
                  height: 16,
                  width: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                  ),
                  child: Text(
                    Utility.readTimestamp(model.timestamp),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 6,
            ),
            child: _buildStatus(model),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus(VehicleModel model) {
    String status;
    Color statusColor;
    (status, statusColor) = Utility.getStatusText(model);
    return Row(
      children: [
        Container(
          height: 16,
          width: 16,
          margin: const EdgeInsets.only(
            top: 1,
            bottom: 2,
          ),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 7,
          ),
          child: Text(
            status,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class VehicleDetailError extends StatelessWidget {
  String? e;
  VoidCallback cb;
  VehicleDetailError({super.key, this.e, required this.cb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          CustomAppbar(
            title: "",
            padding: EdgeInsets.all(20.0),
          ),
          ErrorWidget2(
            text: "Đã có lỗi xảy ra: ${e}",
            btnText: "Thử lại",
            callback: cb,
          )
        ],
      )),
    );
  }
}
