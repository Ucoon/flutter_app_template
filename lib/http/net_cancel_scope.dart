import 'package:dio/dio.dart';

class CancelScope {
  String? key;

  static Map<String, CancelToken> mCancelTokenOfTags =
      <String, CancelToken>{};

  bool mCleared = false;

  CancelToken get() {
    CancelToken? cancel = getTag(key!);
    if (cancel != null) {
      return cancel;
    }
    return setTagIfAbsent(key!, CancelToken());
  }

  clear() {
    mCleared = true;
    mCancelTokenOfTags.forEach((key, value) {
      close(value);
    });
  }

  CancelToken? getTag(String tag) {
    return mCancelTokenOfTags[tag];
  }

  CancelToken setTagIfAbsent(String tag, CancelToken cancelToken) {
    CancelToken? previous = getTag(tag);
    if (previous == null) {
      mCancelTokenOfTags[tag] = cancelToken;
    }
    CancelToken result = previous ?? cancelToken;
    if (mCleared) {
      close(result);
    }
    return result;
  }

  void cancel(String key){
    CancelToken? cancelToken = getTag(key);
    close(cancelToken!);
  }

  void close(CancelToken cancelToken) {
    if (cancelToken.isCancelled) {
      return;
    }
    cancelToken.cancel();
  }
}
