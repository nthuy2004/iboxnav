import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/vehicle_model.dart';

class VehicleListItem extends StatelessWidget {
  VehicleListItem({required this.item, required this.callback, super.key});
  final void Function() callback;
  final VehicleModel item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      child: GestureDetector(
          onTap: () => callback(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey[200]!,
                  offset: const Offset(12, 12),
                  blurRadius: 16,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 14, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            item.vehicleId,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 6,
                            ),
                            child: _buildStatus(item),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 6,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/img_dashboard.svg",
                                  height: 16,
                                  width: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                  ),
                                  child: Text(
                                    "${item.speed} km/h",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(right: 30),
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset("assets/images/img_car.svg"),
                    ))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

Widget _buildStatus(VehicleModel model) {
  String status;
  Color sttColor;
  (status, sttColor) = Utility.getStatusText(model);

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
          color: sttColor,
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
