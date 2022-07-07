import 'package:flutter/material.dart';

import 'badge.dart';

///圆点数字/红点提醒
class BadgeWidget extends StatelessWidget {
  final int count;
  final bool isDot;
  final double elevation;
  final bool toAnimate;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color badgeColor;
  // final BorderSide? borderSide;
  final TextStyle textStyle;
  final EdgeInsetsGeometry? badgePadding;
  final EdgeInsetsGeometry? badgeMargain;
  final EdgeInsetsGeometry? childPadding;
  final Widget child;
  final ShapeBorder? shape;

  const BadgeWidget({
    Key? key,
    required this.child,
    this.count = 0,
    this.isDot = false,
    this.elevation = 2,
    this.toAnimate = false,
    this.borderRadius,
    // this.borderSide,
    this.shape = const CircleBorder(),
    this.padding,
    this.badgePadding,
    this.badgeMargain,
    this.childPadding,
    this.badgeColor = Colors.red,
    // this.position,
    this.textStyle = const TextStyle(
      fontSize: 10,
      color: Colors.white,
    ),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String _num = count > 99 ? '99+' : count.toString();
    return isDot || count != 0
        ? Badge(
            shape: shape,
            childPadding: childPadding,
            borderRadius: borderRadius,
            badgeMargain: badgeMargain,
            //  ?? BorderRadius.circular(9.r),
            // borderSide: borderSide ?? BorderSide.none,
            elevation: elevation,
            // toAnimate: toAnimate,
            child: child,
            badgeBackground: badgeColor,
            badgePadding: badgePadding ?? const EdgeInsets.all(3),
            badgeContent: isDot
                ? null
                : Container(
                    // height: 16.w,
                    alignment: Alignment.center,
                    // padding: badgePadding ?? EdgeInsets.zero,
                    child: Text(
                      _num,
                      style: textStyle,
                    ),
                  ),
          )
        : Container(padding: childPadding, child: child);
  }
}
