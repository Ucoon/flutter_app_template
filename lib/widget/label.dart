import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

///文本带标签(水平方向)
class Label extends StatelessWidget {
  final String? label;
  final double? iconSize;
  final String? img;
  final Axis direction;
  final Color textColor;
  final double fontSize;
  final double space; //标签和文本的间距

  const Label(
    this.label,
    this.img, {
    Key? key,
    this.direction = Axis.horizontal,
    this.iconSize,
    this.textColor = Colors.white,
    this.fontSize = 11,
    this.space = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          WidgetSpan(
            child: SizedBox(
              width: iconSize ?? 15.w,
              height: iconSize ?? 15.w,
              child: Image.asset(
                "assets/images/$img.png",
              ),
            ),
          ),
          WidgetSpan(
            child: SizedBox(
              width: direction == Axis.horizontal ? space : 0,
              height: direction == Axis.horizontal ? 0 : space,
            ),
          ),
          TextSpan(
            text: direction == Axis.horizontal ? label : '\n$label',
            style: TextStyle(color: textColor, fontSize: fontSize),
          )
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
