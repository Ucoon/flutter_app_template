import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension BottomHeight on GetInterface {
  double get bottomHeight {
    return bottomBarHeight / pixelRatio;
  }
}

extension MediaRemoveBottom on BuildContext {
  Widget removeBottomPadding([Widget? child]) {
    final bottom = MediaQuery.of(this).padding.bottom;
    return MediaQuery.removePadding(
      context: this,
      child: Container(padding: EdgeInsets.only(bottom: bottom), child: child),
    );
  }
}
