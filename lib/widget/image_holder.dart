import 'dart:async';
import 'package:flutter/material.dart';

/// 外部持有；保证图片一直存活
class ImageHolder {
  ImageHolder({required this.image});
  ImageHolder.asset(String name) : image = AssetImage(name);

  final ImageProvider image;

  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;

  Completer<void>? _completer;
  bool _completed = false;
  Future<void>? get future {
    if (_completed) return null;
    _completer ??= Completer<void>();
    return _completer!.future;
  }

  void _complete() {
    if (_completer != null) {
      _completer!.complete();
      _completer = null;
    }
    _completed = true;
  }

  void init(BuildContext context) {
    if (_imageStreamListener != null) return;
    _imageStreamListener ??= ImageStreamListener(_listen, onError: _onError);

    _imageStream = image.resolve(createLocalImageConfiguration(context));
    _imageStream!.addListener(_imageStreamListener!);
  }

  ImageInfo? _info;
  void _listen(ImageInfo? info, bool sync) {
    _info?.dispose();
    _info = info;
    _complete();
  }

  void _onError(e, s) {
    debugPrint('error: $e, $s');
  }

  void dispose() {
    _info?.dispose();
    if (_imageStreamListener != null) {
      _imageStream?.removeListener(_imageStreamListener!);
    }
    _info = null;
    _imageStream = null;
    _imageStreamListener = null;
  }
}
