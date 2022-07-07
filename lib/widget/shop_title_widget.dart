import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'image.dart';

class ShopTitleWidget extends StatelessWidget {
  final String storeImageUrl;
  final String storeName;
  const ShopTitleWidget({
    Key? key,
    this.storeImageUrl = '',
    this.storeName = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        loadImage(
          storeImageUrl,
          width: 25.w,
          height: 25.w,
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          storeName,
          style: TextStyle(
            color: const Color(0xFF3C424D),
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
