import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WidgetUtil {
  static bool isEmpty(Object? value) {
    if (value == null) return true;
    if (value is String && value.isEmpty) {
      return true;
    }
    return false;
  }

  /// 获取图片宽高，加载错误情况返回 Rect.zero.（单位 px）
  static Future<Rect> getImageWH({
    Image? image,
    String? url,
    String? localUrl,
    String? package,
  }) {
    if (isEmpty(image) && isEmpty(url) && isEmpty(localUrl)) {
      return Future.value(Rect.zero);
    }
    Completer<Rect> completer = Completer<Rect>();
    Image img = image ??
        ((url != null && url.isNotEmpty)
            ? Image.network(url)
            : Image.asset(localUrl!, package: package));
    late ImageStreamListener listener;
    final stream = img.image.resolve(const ImageConfiguration());
    stream.addListener(listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        completer.complete(Rect.fromLTWH(
            0, 0, info.image.width.toDouble(), info.image.height.toDouble()));
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          stream.removeListener(listener);
          // info.dispose();
        });
      },
      onError: (Object exception, StackTrace? stackTrace) {
        completer.completeError(exception, stackTrace);
        stream.removeListener(listener);
      },
    ));
    return completer.future;
  }
}
