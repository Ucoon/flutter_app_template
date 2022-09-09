import 'package:flutter/material.dart';
import 'package:flutter_app_template/common/values/values.dart';

///卡片式布局
class EmptyCardWidget extends StatelessWidget {
  final Widget child;
  final double? width; //宽
  final double? height; //高
  final Color color; //背景颜色
  final double elevation; //阴影
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderSide side; //边框
  final BorderRadiusGeometry? borderRadius; // 圆角值

  const EmptyCardWidget({
    Key? key,
    required this.child,
    this.color = Colors.white,
    this.elevation = 0,
    this.side = BorderSide.none,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: width,
        height: height,
        padding: padding,
        child: child,
      ),
      color: color,
      elevation: elevation,
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: side,
        borderRadius: borderRadius ?? borderRadius15,
      ),
    );
  }
}
