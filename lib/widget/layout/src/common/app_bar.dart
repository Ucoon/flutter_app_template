import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/values/values.dart';

PreferredSize buildAppBar(
  BuildContext context,
  String text, {
  double fontSize = 18.0,
  double elevation = 0,
  Widget? subTitle,
  Widget? leading,
  PreferredSizeWidget? bottom,
  Widget? titleIcon,
  Color backgroundColor = Colors.white,
  Color titleColor = const Color(0xFF373737),
  bool centerTitle = true,
  bool canBack = true,
  double? toolbarHeight,
  List<Widget>? actions,
  VoidCallback? onBackClick,
  ShapeBorder? shape,
  double preferredHeight = 60,
  SystemUiOverlayStyle? systemOverlayStyle,
}) {
  return PreferredSize(
    child: AppBar(
      elevation: elevation,
      // 阴影
      centerTitle: centerTitle,
      toolbarHeight: toolbarHeight,
      titleSpacing: 0,
      shape: shape,
      automaticallyImplyLeading: false,
      systemOverlayStyle: systemOverlayStyle,
      bottom: bottom,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          titleIcon ?? const SizedBox(),
          Flexible(
            child: Padding(
              padding: titleIcon == null
                  ? EdgeInsets.zero
                  : EdgeInsets.only(left: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: titleColor,
                      fontWeight: boldFont,
                    ),
                  ),
                  subTitle ?? const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
      leading: canBack
          ? leading ??
              DefaultAppBarLeadingWidget(
                leadingIconColor: titleColor,
                onBackClick: onBackClick,
              )
          : null,
      actions: actions,
      backgroundColor: backgroundColor,
    ),
    preferredSize: Size.fromHeight(preferredHeight.h),
  );
}

class DefaultAppBarLeadingWidget extends StatelessWidget {
  final Color? leadingIconColor;
  final VoidCallback? onBackClick;
  const DefaultAppBarLeadingWidget({
    Key? key,
    this.leadingIconColor,
    this.onBackClick,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 44.h,
      width: 44.w,
      child: TextButton(
        child: Icon(
          Icons.arrow_back_ios_rounded,
          color: leadingIconColor ?? const Color(0xFF373737),
          size: 20.w,
        ),
        onPressed: () {
          onBackClick != null ? onBackClick!() : Get.back();
        },
      ),
    );
  }
}
