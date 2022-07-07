import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///自适应包裹组件
class WrapWidget extends StatelessWidget {
  final List<Widget> children;
  final double runSpacing;
  final WrapCrossAlignment crossAlignment;

  const WrapWidget({
    Key? key,
    required this.children,
    this.runSpacing = 0,
    this.crossAlignment = WrapCrossAlignment.start,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      // 排列方向，默认水平方向排列
      alignment: WrapAlignment.start,
      // 子控件在主轴上的对齐方式
      spacing: 12.w,
      // 主轴上子控件中间的间距
      runAlignment: WrapAlignment.start,
      // 子控件在交叉轴上的对齐方式
      runSpacing: runSpacing,
      // 交叉轴上子控件之间的间距
      crossAxisAlignment: crossAlignment,
      // 交叉轴上子控件的对齐方式
      textDirection: TextDirection.ltr,
      // 水平方向上子控件的起始位置
      verticalDirection: VerticalDirection.down,
      // 垂直方向上子控件的起始位置
      children: children,
    );
  }
}
