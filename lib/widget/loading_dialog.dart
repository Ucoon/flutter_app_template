import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common/values/values.dart';

void showLoadingDialog({
  bool barrierDismissible = false,
  Color barrierColor = Colors.transparent,
}) {
  Get.dialog(
    const LoadingDialog(),
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
  );
}

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 100.w,
        height: 100.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF2F3B46),
          borderRadius: borderRadius8,
        ),
        child: Image.asset(
          'assets/images/ic_loading_dialog.gif',
          width: 32.w,
          height: 32.w,
        ),
      ),
    );
  }
}
