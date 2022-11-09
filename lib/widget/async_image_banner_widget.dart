import 'package:flutter/material.dart';
import '/common/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart'
    as my_carousel_comp;

class AsyncImageBannerWidget extends StatefulWidget {
  const AsyncImageBannerWidget({
    Key? key,
    required this.children,
    required this.defaultImage,
    this.padding,
    this.onTap,
  }) : super(key: key);
  final List<Widget> children;
  final void Function(int)? onTap;
  final String defaultImage;

  final EdgeInsets? padding;
  @override
  State<AsyncImageBannerWidget> createState() => _AsyncImageBannerState();
}

class _AsyncImageBannerState extends State<AsyncImageBannerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return const SizedBox();
    return renderAsyncItem(widget.defaultImage);
  }

  Future<Size> loadAsync(String url) async {
    var baseR = await WidgetUtil.getImageWH(url: url);
    Size baseSize = baseR.size;
    return baseSize;
  }

  Widget renderAsyncItem(String imageUrl) {
    final padding = widget.padding ??
        EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w);
    final horizontalSpace = padding.horizontal;

    return FutureBuilder<Size>(
      future: loadAsync(imageUrl),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final size = snapshot.data!;
          final imageHeight = size.height;
          final imageWidth = size.width;
          return LayoutBuilder(builder: (context, constraints) {
            var maxWidth = constraints.maxWidth - horizontalSpace;
            final fac = imageWidth / maxWidth;
            var realHeight = imageHeight / fac;

            return Container(
              width: maxWidth,
              height: realHeight,
              margin: padding,
              child: my_carousel_comp.Carousel(
                images: widget.children,
                indicatorBgPadding: 8,
                radius: const Radius.circular(0),
                animationCurve: Curves.easeOutQuart,
                onImageChange: (a, b) {},
                onImageTap: widget.onTap,
                dotSize: 4.w,
                dotSpacing: 10,
                showIndicator: widget.children.length > 1,
                dotColor: Colors.white.withOpacity(0.4),
                dotIncreasedColor: Colors.white,
                dotBgColor: Colors.transparent,
              ),
            );
          });
        }
        return _placeholder();
      }),
    );
  }

  Widget _placeholder() {
    return SizedBox(width: ScreenUtil().screenWidth, height: 120.h);
  }
}
