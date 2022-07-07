///正则匹配工具类
class RegExpKit {
  ///手机号验证(只验证前三位号段)
  static bool checkMobile(String str) {
    return RegExp(r"^1[3456789]\d{9}$").hasMatch(str);
  }

  ///马来西亚手机号验证(只验证前三位号段)
  static bool checkMSMobile(String str) {
    return RegExp(r"^(601|01|1)[145]1\d{7}$").hasMatch(str);
  }

  ///邮箱验证
  static bool checkEmail(String str) {
    return RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        .hasMatch(str);
  }

  ///验证URL
  static bool isUrl(String value) {
    return RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+").hasMatch(value);
  }

  ///验证身份证
  static bool isIdCard(String value) {
    return RegExp(r"\d{17}[\d|x]|\d{15}").hasMatch(value);
  }

  ///验证中文
  static bool containChinese(String value) {
    return RegExp(r".*[\u4e00-\u9fa5].*").hasMatch(value);
  }

  ///数字验证
  static bool checkNumber(String value) {
    return RegExp(r"^[0-9]\d*\.?\d*$").hasMatch(value);
  }

  ///数字加字母
  static bool checkNumberAndLetter(String value) {
    return RegExp(r"^[a-zA-Z0-9]*$").hasMatch(value);
  }
}
