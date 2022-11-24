import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'storage.dart';
import '../values/values.dart';

///多语言设置
class LocaleUtil {
  ///切换语言
  static Future<void> saveAppLocale(Locale locale) {
    Get.updateLocale(locale);
    return StorageUtil().putJSON(storageLangKey, getAppLang(locale));
  }

  static String? getAppLocale() {
    return StorageUtil().getJSON(storageLangKey);
  }

  static String getAppLang(Locale locale) {
    String code = locale.languageCode;
    if (code == 'zh') {
      return 'zh_CN';
    }
    if (code == 'en') {
      return 'en_US';
    }
    return 'en_US';
  }

  static Locale getLocalLocale() {
    String? lang = getAppLocale();
    if (lang == 'zh_CN') {
      return const Locale('zh', 'CN');
    }
    return const Locale('en', 'US');
  }
}
