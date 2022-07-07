import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'big_image_widget.dart';
import 'image.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({Key? key, this.imageUrl}) : super(key: key);
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // SizedBox(
        //     width: 116.w,
        //     height: 116.w,
        //     // color: const Color(0xFFF5F5F5),
        //     child: loadImage(
        //       imageUrl ?? '',
        //       width: 116.w,
        //       height: 116.w,
        //     )),
        BigImageWidget(
            imageUrl: imageUrl ?? '',
            images: [imageUrl ?? ''],
            constraints: BoxConstraints(maxWidth: 116.w, maxHeight: 116.w)),
        Positioned(
          top: 0,
          right: 0,
          child: getIconPng('ic_zoom', iconSize: 24.w),
        ),
      ],
    );
  }
}
