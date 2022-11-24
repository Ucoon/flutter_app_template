import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/local_util.dart';
import 'en_us.dart';
import 'zh_cn.dart';

class TranslationService extends Translations {
  static Locale? get locale => LocaleUtil.getLocalLocale();
  static const fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'zh_CN': zhCN,
      };
}
