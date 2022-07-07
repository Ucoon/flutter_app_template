import 'package:flutter/services.dart';
import 'dart:math' as math;

class CustomTextFieldFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;

  ///允许的小数位数，-1代表不限制位数，默认为-1
  final int digit;
  //重写构造方法，可以对位数进行直接限制
  CustomTextFieldFormatter({this.digit = -1});

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  ///获取目前的小数位数
  static int getValueDigit(String value) {
    if (value.contains(".")) {
      return value.split(".")[1].length;
    } else {
      return -1;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    // 如果输入框内容为.直接将输入框赋值为0.
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value != "" &&
            value != defaultDouble.toString() &&
            strToFloat(value, defaultDouble) == defaultDouble ||
        getValueDigit(value) == 0 && digit == 0 ||
        getValueDigit(value) > digit) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    // 通过最上面的判断，这里返回的都是有限金额形式
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class ClampInputTextFiledFormatter extends TextInputFormatter {
  final int maxLength;
  ClampInputTextFiledFormatter({this.maxLength = 0});
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (maxLength < 1) {
      return newValue;
    }
    final offset = newValue.selection.end;
    final newOffset = math.min(maxLength, offset);
    final text = newValue.text;
    if (offset == newOffset && text.length <= maxLength) return newValue;
    return newValue.copyWith(
        text: newValue.text.substring(0, newOffset),
        selection: TextSelection.collapsed(offset: newOffset));
  }
}
