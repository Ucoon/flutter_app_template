import 'dart:async';
import 'dart:math';

List<List<T>> chunk<T>(List<T> list, int size) {
  return List.generate(
    (list.length / size).ceil(),
    (i) => list.sublist(
      i * size,
      min(i * size + size, list.length),
    ),
  );
}

Map<TKey, List<T>> groupBy<T, TKey>(Iterable<T> list, TKey Function(T) fn) {
  return Map.fromIterable(
    list.map(fn).toSet(),
    value: (i) => list.where((v) => fn(v) == i).toList(),
  );
}

List<T1> map<T1, T2>(List<T2> list, T1 Function(int ix, T2 it) fn) {
  List<T1> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(fn(i, list[i]));
  }

  return result;
}

List<T1> mapJoin<T1, T2>(
  List<T2> list,
  Function(int ix, T2 it) fn,
  T1 Function(int ix, T2 it) separatorFn,
) {
  List<T1> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(fn(i, list[i]));
    if (i < list.length - 1) {
      result.add(separatorFn(i, list[i]));
    }
  }

  return result;
}

Function()? debounce(
  Function func, [
  Duration delay = const Duration(milliseconds: 500),
]) {
  Timer? timer;
  target() {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func.call();
    });
  }

  return target;
}

Function throttle(
  Future Function()? func,
) {
  if (func == null) {
    return func!;
  }
  bool enable = true;
  target() {
    if (enable == true) {
      enable = false;
      func().then((_) {
        enable = true;
      });
    }
  }

  return target;
}

/// Examples
/// mapList([1, 2, 3], (a) => a * a); // [{1: 1, 2: 4, 3: 9}]
Map<T, Y> mapList<T, Y>(Iterable<T> itr, Y Function(T) fn) {
  return {for (var i in itr) i: fn(i)};
}

/// Examples
/// all([4, 2, 3], (x) => x > 1); // true
bool all<T>(Iterable<T> itr, bool Function(T) fn) {
  return itr.every(fn);
}

/// Examples
/// some([0, 1, 2, 0], (x) => x >= 2); // true
bool some<T>(Iterable<T> itr, bool Function(T) fn) {
  return itr.any(fn);
}

List<MapEntry<K, V>> mapToList<K, V>(Map<K, V> data) {
  List<MapEntry<K, V>> list = [];
  data.forEach((key, value) {
    list.add(MapEntry<K, V>(key, value));
  });
  return list;
}

int parseInt(dynamic data) {
  if (data is int) {
    return data;
  }

  if (data is String) {
    return int.parse(data);
  }

  if (data is bool) {
    return data ? 1 : 0;
  }

  if (data is double) {
    return data.toInt();
  }

  return data;
}

dynamic getKeyByValue(Map<dynamic, dynamic> map, dynamic value) {
  if (!map.values.contains(value)) return null;
  List keys = List.from(map.keys.toList());
  int targetIndex = keys.indexWhere((element) => map[element] == value);
  if (targetIndex == -1) return null;
  return keys[targetIndex];
}
