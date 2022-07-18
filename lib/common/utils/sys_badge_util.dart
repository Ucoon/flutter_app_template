import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'dart:math' as math;

class UpdateBSysBadgeState {
  UpdateBSysBadgeState();
  late int unReadCount;

  late bool supported;
  int _cacheIndex = 0;
  bool _inited = false;

  Future<void> init(int count) async {
    unReadCount = count - _cacheIndex;
    supported = await FlutterAppBadger.isAppBadgeSupported();
    _inited = true;
    _update();
  }

  int get _clampCount => math.max(0, unReadCount);

  void increase() {
    if (!_inited) {
      _cacheIndex++;
      return;
    }
    if (supported) {
      unReadCount++;
      _update();
    }
  }

  void _update() {
    if (_clampCount == 0) {
      FlutterAppBadger.removeBadge();
    }
    FlutterAppBadger.updateBadgeCount(_clampCount);
  }

  void decrease() {
    if (!_inited) {
      _cacheIndex--;
      return;
    }
    if (supported) {
      unReadCount--;
      _update();
    }
  }
}
