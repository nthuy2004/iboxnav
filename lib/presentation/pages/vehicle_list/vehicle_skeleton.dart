import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class VehicleSkeleton extends StatelessWidget {
  const VehicleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
        shimmerGradient: LinearGradient(
          colors: [
            Colors.grey[200]!,
            Colors.grey[300]!,
            Colors.grey[200]!,
          ],
          stops: const [
            0.1,
            0.5,
            0.9,
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 14, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 20,
                            width: MediaQuery.of(context).size.width / 2,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 16,
                            width: MediaQuery.of(context).size.width / 3,
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                            height: 16,
                            width: MediaQuery.of(context).size.width / 3.5,
                            borderRadius: BorderRadius.circular(6)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
