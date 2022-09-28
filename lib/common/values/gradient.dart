import 'package:flutter/material.dart';

Gradient buildTopToBottomLinearGradient({
  required List<Color> colors,
  List<double> stops = const <double>[0.0, 1.0],
}) {
  return LinearGradient(
    begin: Alignment.topCenter, //渐变开始位置
    end: Alignment.bottomCenter, //渐变结束位置
    stops: stops, //[渐变起始点, 渐变结束点]
    colors: colors, //渐变颜色[始点颜色, 结束颜色]
  );
}

Gradient buildLeftToRightLinearGradient({
  required List<Color> colors,
  List<double> stops = const <double>[0.0, 1.0],
}) {
  return LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: stops,
    colors: colors,
  );
}
