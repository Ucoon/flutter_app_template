import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'image.dart';

Widget buildGoToIconWidget({
  double? iconSize,
  Color iconColor = const Color(0xFFA3A3A3),
}) {
  return Icon(
    Icons.arrow_forward_ios_rounded,
    size: iconSize ?? 16.w,
    color: iconColor,
  );
}

Widget buildDialogClosedWidget(BuildContext context,
    {BorderRadius? borderRadius}) {
  return InkWell(
    borderRadius: borderRadius,
    onTap: () {
      Navigator.of(context).pop(false);
    },
    child: getIconPng(
      'ic_dialog_grey',
      iconSize: 54.w,
    ),
  );
}

Widget buildLoading({double iconSize = 64}) {
  return Image.asset(
    'assets/images/ic_loading.gif',
    width: iconSize.w,
    height: iconSize.w,
  );
}
