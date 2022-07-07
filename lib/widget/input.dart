import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 输入框
/// 背景白色，文字黑色,无边框
Widget inputTextEdit({
  TextEditingController? controller,
  Function(String value)? onChanged,
  Function(String value)? onSubmitted,
  TextInputType keyboardType = TextInputType.text,
  TextInputAction? textInputAction = TextInputAction.done,
  String? hintText,
  bool isPassword = false,
  double marginTop = 15,
  bool autofocus = false,
  double? height,
  bool hasBordered = false,
  int maxLength = 999999,
}) {
  return Container(
    color: Colors.white,
    margin: EdgeInsets.only(top: marginTop.h),
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(20, height ?? 10, 0, 9),
        border: hasBordered
            ? OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(
                  color: const Color(0xFFBDBDBD),
                  width: 1.w,
                ),
              )
            : InputBorder.none,
      ),
      style: TextStyle(
        color: const Color(0xFF3C424D),
        fontWeight: FontWeight.w400,
        fontSize: 16.sp,
      ),
      autocorrect: false,
      // 自动纠正
      obscureText: isPassword, // 隐藏输入内容, 密码框
    ),
  );
}

/// 输入框
/// 背景白色，文字黑色，无边框，带分割线
Widget inputNoBorderWithDividerEdit({
  TextEditingController? controller,
  Function(String value)? onChanged,
  Function(String value)? onSubmitted,
  TextInputAction? textInputAction = TextInputAction.done,
  TextInputType keyboardType = TextInputType.text,
  String? hintText,
  bool isPassword = false,
  double marginTop = 15,
  bool autoFocus = false,
  int? maxLength,
  Widget? icon,
  double? fontSize = 13,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Container(
    margin: EdgeInsets.only(top: marginTop.h),
    width: double.infinity,
    color: Colors.white,
    child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Row(
            children: [
              icon ?? const SizedBox(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 14.w),
                  child: TextField(
                    autofocus: autoFocus,
                    controller: controller,
                    keyboardType: keyboardType,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    textInputAction: textInputAction,
                    inputFormatters: inputFormatters,
                    maxLength: maxLength,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: const Color(0xFFC4C4C6),
                        fontSize: fontSize,
                      ),
                      counterText: '',
                    ),
                    style: TextStyle(
                      color: const Color(0xFF3C424D),
                      fontSize: fontSize,
                    ),
                    maxLines: 1,
                    autocorrect: false,
                    obscureText: isPassword, // 隐藏输入内容, 密码框
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(
          color: const Color(0xFFBDBDBD),
          thickness: 0.5.h,
          height: 10.h,
        ),
      ],
    ),
  );
}

/// 背景透明，文字颜色自定义,无边框，无间距
Widget simpleInputTextEdit({
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  TextInputAction? textInputAction = TextInputAction.done,
  TextAlign textAlign = TextAlign.right,
  Function(String value)? onChanged,
  int maxLength = 99,
  int? maxLines,
  String? hintText,
  String? initialValue,
  TextStyle? hintStyle,
  TextStyle? textStyle,
  bool showCounter = false,
  List<TextInputFormatter>? inputFormatters,
  FocusNode? focusNode,
}) {
  return TextFormField(
    focusNode: focusNode,
    controller: controller,
    initialValue: initialValue,
    keyboardType: keyboardType,
    onChanged: onChanged,
    textInputAction: textInputAction,
    inputFormatters: inputFormatters,
    maxLength: maxLength,
    maxLines: maxLines,
    textAlign: textAlign,
    decoration: InputDecoration(
      counterText: showCounter ? null : '',
      hintText: hintText,
      hintStyle: hintStyle ??
          TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFFCDCDD0),
          ),
      isDense: true,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
    ),
    style: textStyle ??
        TextStyle(
          fontSize: 13.sp,
          color: const Color(0xFF85878B),
        ),
  );
}

class TextFormFieldWidget extends StatelessWidget {
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String hintText;
  final int? maxLength;
  final int? maxLines;
  final bool obscureText;
  final bool enabled;
  final Function(String)? onChanged;
  final String? counterText;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;

  const TextFormFieldWidget({
    Key? key,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.hintText = '',
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    this.controller,
    this.counterText,
    this.initialValue,
    this.obscureText = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      obscureText: obscureText,
      controller: controller,
      enabled: enabled,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xFFC2C3C6),
          fontSize: 13.sp,
        ),
        counterText: counterText,
      ),
      maxLength: maxLength,
      maxLines: maxLines,
    );
  }
}
