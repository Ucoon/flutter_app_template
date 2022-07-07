import 'package:flutter/services.dart';

///剪切板工具类
class ClipboardKit {
  ///复制文本到剪切板
  static Future<void> setData(String content) async {
    if (content.isEmpty) return;
    return Clipboard.setData(ClipboardData(text: content));
  }

  ///从剪切板读取文本
  static Future<ClipboardData?> getData() {
    return Clipboard.getData(Clipboard.kTextPlain);
  }
}
