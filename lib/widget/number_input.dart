import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'toast.dart';

class NumberInputWidget extends StatelessWidget {
  final int initialValue;
  final String placeholder;
  final int step;
  final Function? onSaved;
  final bool isEnable; //是否能操作
  final Color inputBgColor; //输入框背景色
  final Color inputColor;
  final Color iconColor;
  final int maxNum;

  NumberInputWidget({
    Key? key,
    this.placeholder = '',
    this.initialValue = 0,
    this.step = 1,
    this.isEnable = true,
    this.inputColor = const Color(0xFFF2CBC1),
    this.inputBgColor = Colors.white,
    this.iconColor = const Color(0xFF757575),
    this.onSaved,
    this.maxNum = 9223372036854775807,
  }) : super(key: key) {
    _controller.text = initialValue.toString();
  }

  final TextEditingController _controller = TextEditingController();

  void _onChange(String value) {
    final numValue = int.tryParse(value);
    if (numValue == null || onSaved == null) return;
    if (numValue < 1) {
      toastInfo(msg: 'min_num_out'.tr);
      return;
    }
    if (numValue > maxNum) {
      toastInfo(msg: 'max_num_out'.tr);
      return;
    }
    onSaved!.call(numValue);
  }

  void _onNumChange(int value) {
    if (value < 1) {
      toastInfo(msg: 'min_num_out'.tr);
      return;
    }
    if (value > maxNum) {
      toastInfo(msg: 'max_num_out'.tr);
      return;
    }
    _controller.text = value.toString();
    if (onSaved == null) return;
    onSaved!.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: isEnable
              ? () {
                  final value = (int.tryParse(_controller.text) ?? 1) - step;
                  _onNumChange(value);
                }
              : null,
          child: Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: const Color(0xFFE6E6E6), width: 1.w),
                top: BorderSide(color: const Color(0xFFE6E6E6), width: 1.w),
                bottom: BorderSide(color: const Color(0xFFE6E6E6), width: 1.w),
              ),
            ),
            child: Icon(
              Icons.remove,
              size: 10.w,
              color: iconColor,
            ),
          ),
        ),
        Container(
          width: 40.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE6E6E6), width: 1.w),
          ),
          alignment: Alignment.center,
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            maxLength: 3,
            style: TextStyle(
              color: inputColor,
              fontSize: 13.sp,
            ),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: placeholder,
              hintStyle: TextStyle(
                color: const Color(0xFFF2CBC1),
                fontSize: 13.sp,
              ),
              enabled: isEnable,
            ),
            onChanged: _onChange,
          ),
        ),
        InkWell(
          onTap: isEnable
              ? () {
                  final value = (int.tryParse(_controller.text) ?? 0) + step;
                  _onNumChange(value);
                }
              : null,
          child: Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: const Color(0xFFE6E6E6), width: 1.w),
                top: BorderSide(color: const Color(0xFFE6E6E6), width: 1.w),
                bottom: BorderSide(color: const Color(0xFFE6E6E6), width: 1.w),
              ),
            ),
            child: Icon(
              Icons.add,
              size: 10.w,
              color: iconColor,
            ),
          ),
        ),
      ],
    );
  }
}
