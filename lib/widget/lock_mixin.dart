/// 锁定一个异步任务，避免多次调用引起的数据问题
mixin LockMixin {
  Object? _lock;

  Object genNewLock() {
    return _lock = Object();
  }

  bool isCurrentLock(Object key) => _lock == key;

  bool isNotCurrent(Object key) => _lock != key;

  void resetLock() {
    _lock = null;
  }
}

/// 以对象存在
class Lock with LockMixin {}
