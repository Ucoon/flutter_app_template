import 'package:flutter/material.dart';
import 'dart:math' as math;

/// FlowDelegate
///
/// 当前实现：只支持单行布局，如果children超过布局数量的话会忽略掉后面的的[Widget]
class IconStackFlowDelegate extends FlowDelegate {
  IconStackFlowDelegate({
    required this.maxExtent,
    required this.itemExtent,
    this.axisDirection = AxisDirection.left,
    this.overlaps = 0.0,
  });

  // 交叉轴的高度
  final double maxExtent;
  // 单个
  final Size itemExtent;

  // 只支持左右布局
  final AxisDirection axisDirection;

  // 重叠的部分
  final double overlaps;

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.constrainHeight(maxExtent));
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final childCount = context.childCount;
    if (childCount <= 0) return;

    final childSize = context.getChildSize(0);
    // final extent = math.min(childSize!.width, itemExtent.width);
    final extent = childSize!.width;

    // 除了第一个child的总容量
    final otherExtent = size.width - extent;
    //
    final extentWithOverlaps = extent - overlaps;

    // 反方向的布局会有额外的宽度
    var extraWidth = 0.0;

    if (extentWithOverlaps > 0 && otherExtent > 0) {
      final realCount = otherExtent ~/ extentWithOverlaps + 1;
      var index = math.min(childCount, realCount) - 1;

      if (isRevese) {
        extraWidth = size.width - index * extentWithOverlaps - childSize.width;
      }
      while (index > 0) {
        final transform = Matrix4.translationValues(
            extraWidth + index * extentWithOverlaps, 0, 0);
        context.paintChild(index, transform: transform);
        index--;
      }
    } else {
      if (isRevese) {
        extraWidth = size.width - childSize.width;
      }
    }
    context.paintChild(0,
        transform: Matrix4.translationValues(extraWidth, 0, 0));
  }

  bool get isRevese =>
      axisDirection == AxisDirection.right ||
      axisDirection == AxisDirection.down;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return constraints.tighten(
        width: itemExtent.width, height: itemExtent.height);
  }

  @override
  bool shouldRepaint(covariant IconStackFlowDelegate oldDelegate) {
    return maxExtent != oldDelegate.maxExtent ||
        itemExtent != oldDelegate.itemExtent ||
        overlaps != oldDelegate.overlaps ||
        axisDirection != oldDelegate.axisDirection;
  }
}
