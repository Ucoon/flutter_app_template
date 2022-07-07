import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储
class StorageUtil {
  static late final StorageUtil _singleton = StorageUtil._internal();
  late SharedPreferences _prefs;

  factory StorageUtil() => _singleton;

  StorageUtil._internal();

  Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> putJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _prefs.setString(key, jsonString);
  }

  dynamic getJSON(String key) {
    String? jsonString = _prefs.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  String getString(String key, {String defValue = ''}) {
    if (!_prefs.containsKey(key)) return defValue;
    return _prefs.getString(key) ?? defValue;
  }

  Future<bool>? putString(String key, String value) {
    return _prefs.setString(key, value);
  }

  bool getBool(String key, {bool defValue = false}) {
    if (!_prefs.containsKey(key)) return defValue;
    return _prefs.getBool(key) ?? defValue;
  }

  Future<bool>? putBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  int getInt(String key, {int defValue = 0}) {
    if (!_prefs.containsKey(key)) return defValue;
    return _prefs.getInt(key) ?? defValue;
  }

  Future<bool>? putInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  bool? haveKey(String key) {
    return getKeys().contains(key);
  }

  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  Future<bool>? remove(String key) {
    return _prefs.remove(key);
  }

  Future<bool>? clear() {
    return _prefs.clear();
  }
}
