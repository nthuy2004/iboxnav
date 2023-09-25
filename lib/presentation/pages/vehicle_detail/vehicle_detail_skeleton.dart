import 'package:flutter/material.dart';
import 'package:iboxnav/presentation/components/appbar.dart';
import 'package:skeletons/skeletons.dart';

class VehicleDetailSkeleton extends StatelessWidget {
  const VehicleDetailSkeleton({super.key});

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
      child: Scaffold(
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTop(context),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          child: Column(
                        children: [Expanded(child: _skeleton(context))],
                      )),
                    ),
                    Container(
                        height: 58,
                        width: double.maxFinite,
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                              height: double.maxFinite,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        )),
                  ],
                ),
              ),
            ))
          ],
        )),
      ),
    );
  }

  Widget _skeleton(context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SkeletonLine(
            style: SkeletonLineStyle(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                width: MediaQuery.of(context).size.width / 2.5),
          ),
          SkeletonListTile(padding: EdgeInsets.symmetric(horizontal: 8)),
          SkeletonParagraph(
            style: SkeletonParagraphStyle(lines: 4),
          ),
        ],
      ),
    );
  }

  Widget _buildTop(context) {
    return Container(
      height: 210,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomAppbar(
              title: "Thông tin xe",
              allowBack: false,
              padding: const EdgeInsets.all(20)),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 10,
            ),
            child: SkeletonLine(
              style: SkeletonLineStyle(
                  height: 30, width: MediaQuery.of(context).size.width / 2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 10,
            ),
            child: SkeletonLine(
                style: SkeletonLineStyle(
                    height: 16, width: MediaQuery.of(context).size.width / 3)),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 10,
            ),
            child: SkeletonLine(
                style: SkeletonLineStyle(
                    height: 16,
                    width: MediaQuery.of(context).size.width / 3.2)),
          ),
        ],
      ),
    );
  }
}
