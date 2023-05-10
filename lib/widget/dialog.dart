import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiver/strings.dart';
import '../common/values/values.dart';
import 'badge.dart';
import 'bottom_height.dart';
import 'element.dart';

///显示带有取消、确认的弹窗
Future<bool> showConfirm(
  BuildContext context,
  String title, {
  Widget? content,
  bool showCloseButton = false,
  bool showFalseButton = true,
  bool outsideDismiss = true, //点击弹窗外部，关闭弹窗，默认为true，true：可以关闭  false：不可以关闭
  String? trueLabel,
  String? falseLabel,
  Function()? trueFunction,
  Function()? falseFunction,
  Widget? falseChild,
  Widget? trueChild,
  TextStyle trueLabelStyle = const TextStyle(
    fontSize: fontSize14,
    color: Color(0xFFCE4031),
  ),
  TextStyle falseLabelStyle = const TextStyle(
    fontSize: fontSize14,
    color: Color(0xFF9C9C9C),
  ),
  Widget Function(BuildContext context, Widget child)? builder,
}) {
  trueLabel ??= 'confirm'.tr;
  falseLabel ??= 'cancel'.tr;
  List<Widget> actions = <Widget>[];
  if (showFalseButton) {
    actions.add(
      Flexible(
        flex: 1,
        child: InkWell(
          onTap: falseFunction ??
              () {
                Navigator.of(context).pop(false);
              },
          child: SizedBox(
            height: 46.h,
            child: Center(
              child: falseChild ??
                  Text(
                    falseLabel,
                    style: falseLabelStyle,
                  ),
            ),
          ),
        ),
      ),
    );
  }
  actions.add(
    Container(
      width: 1,
      height: 46.h,
      color: const Color(0xFFEFEFEF),
    ),
  );
  actions.add(
    Flexible(
      flex: 1,
      child: InkWell(
        onTap: trueFunction ??
            () {
              Navigator.of(context).pop(true);
            },
        child: SizedBox(
          height: 46.h,
          child: Center(
            child: trueChild ??
                Text(
                  trueLabel,
                  style: trueLabelStyle,
                ),
          ),
        ),
      ),
    ),
  );
  return showDialog(
    context: context,
    barrierDismissible: outsideDismiss,
    builder: (ctx) {
      Widget child = Stack(
        children: <Widget>[
          CustomBadge(
            badgeBackground: Colors.transparent,
            childPadding: !showCloseButton ? null : EdgeInsets.all(27.w),
            badgeContent: !showCloseButton
                ? null
                : buildDialogClosedWidget(context,
                    borderRadius: BorderRadius.circular(27.w)),
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius16,
                  color: Colors.white,
                ),
                width: 320.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20.h,
                    ),
                    isBlank(title)
                        ? const SizedBox()
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: fontSize14,
                                fontWeight: boldFont,
                                color: const Color(0xFF3C424D),
                              ),
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      margin: EdgeInsets.only(top: 7.h),
                      child: content ?? const SizedBox(),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Container(
                      height: 1,
                      color: const Color(0xFFEFEFEF),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: actions,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
      if (builder != null) {
        child = builder(context, child);
      } else {
        child = Center(child: child);
      }

      return WillPopScope(
        onWillPop: () async {
          return outsideDismiss;
        },
        child: child,
      );
    },
  ).then((value) => value ?? false);
}

///展示底部弹窗
Future<bool> showBottomDialog(
  BuildContext context,
  Widget child, {
  bool isScrollControlled = true,
  Color color = Colors.white,
  bool removeBottom = true,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    backgroundColor: color,
    enableDrag: enableDrag,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
    ),
    builder: (BuildContext context) {
      if (removeBottom) {
        return context.removeBottomPadding(child);
      }
      return child;
    },
  ).then((value) => value ?? false);
}

///显示中间弹窗
Future<bool> showCenterDialog(
  BuildContext context,
  Widget child, {
  bool barrierDismissible = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return Center(
        child: child,
      );
    },
  ).then((value) => value ?? false);
}

///弹窗取消按钮
class ClosedDialogWidget extends StatelessWidget {
  const ClosedDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.close_rounded,
        size: 24.sp,
        color: const Color(0xFF828282),
      ),
    );
  }
}
