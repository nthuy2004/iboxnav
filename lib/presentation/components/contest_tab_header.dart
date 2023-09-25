import 'package:flutter/material.dart';

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(this.height, this.child);
  final Widget child;
  final double height;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
