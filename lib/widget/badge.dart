import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    Key? key,
    this.alignment = Alignment.topRight,
    this.childPadding = EdgeInsets.zero,
    required this.child,
    this.badgeContent,
    this.elevation = 2,
    this.shape,
    this.badgeBackground,
    this.borderRadius,
    this.badgePadding = const EdgeInsets.all(3),
    this.badgeMargin,
  }) : super(key: key);
  final EdgeInsetsGeometry? childPadding;
  final EdgeInsetsGeometry? badgePadding;
  final EdgeInsetsGeometry? badgeMargin;
  final Alignment alignment;
  final Widget child;
  final Widget? badgeContent;
  final double elevation;
  final ShapeBorder? shape;
  final Color? badgeBackground;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Container(padding: childPadding, child: child),
        Positioned.fill(
          child: Container(
            alignment: alignment,
            margin: badgeMargin,
            child: Material(
              shape: borderRadius != null ? null : shape,
              borderRadius: borderRadius,
              color: badgeBackground,
              child: Container(
                padding: badgePadding,
                child: IntrinsicHeight(
                  child: IntrinsicWidth(child: badgeContent),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
