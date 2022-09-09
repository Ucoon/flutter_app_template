import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/values/values.dart';
import 'badge_widget.dart';

///自定义ListTile
class CustomListTile extends StatelessWidget {
  final Widget? leadingIcon; //左边图标
  final String title; //文字
  final String subTitle; //右边文字
  final Widget? trailingIcon; //右边图标
  final TextStyle titleStyle; //左边文字格式
  final TextStyle subTitleStyle; //右边文字格式
  final EdgeInsetsGeometry leftMargin; //左边图标和文字间距
  final EdgeInsetsGeometry rightMargin; //右边文字和图标间距
  final Widget? subWidget; //右边控件：icon...
  final bool showNotification; //是否显示小红点
  final GestureTapCallback? onTap; //点击事件
  final bool needUnderLine; //是否需要下划线
  const CustomListTile(
    this.title, {
    Key? key,
    this.leadingIcon,
    this.subTitle = '',
    this.trailingIcon,
    this.titleStyle = const TextStyle(
      fontSize: fontSize14,
      color: Color(0xFF1A1A1A),
    ),
    this.subTitleStyle = const TextStyle(
      fontSize: fontSize14,
      color: Color(0xFF1A1A1A),
    ),
    this.leftMargin = const EdgeInsets.only(left: 8),
    this.rightMargin = const EdgeInsets.only(right: 8),
    this.subWidget,
    this.showNotification = false,
    this.onTap,
    this.needUnderLine = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: ScreenUtil().screenWidth,
        padding: EdgeInsets.only(top: 12.h),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                leadingIcon ?? const SizedBox(),
                Container(
                  margin: leftMargin,
                  child: Text(
                    title,
                    style: titleStyle,
                  ),
                ),
                const Spacer(),
                isBlank(subTitle)
                    ? const SizedBox()
                    : Container(
                        margin: rightMargin,
                        child: Text(
                          subTitle,
                          style: subTitleStyle,
                        ),
                      ),
                subWidget ?? const SizedBox(),
                showNotification
                    ? BadgeWidget(
                        isDot: true,
                        borderRadius: borderRadius5,
                        child: const SizedBox(),
                      )
                    : const SizedBox(),
                trailingIcon ?? const SizedBox(),
              ],
            ),
            SizedBox(
              height: needUnderLine ? 11.h : 12.h,
            ),
            needUnderLine
                ? Container(
                    color: const Color(0xFFEFEFEF),
                    height: 1.h,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
