import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class SwiperView extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final double viewportFraction;
  final double scale;
  final double height;
  final double width;
  final int itemCount;
  final bool loop;
  final bool autoplay;
  final Color? activeColor;
  final Color? normalColor;
  final EdgeInsets paginationMargin;
  final EdgeInsets swiperPadding;
  final Function? onClickListener;
  const SwiperView(
    this.itemBuilder, {
    Key? key,
    this.itemCount = 3,
    this.viewportFraction = 0.8,
    this.autoplay = false,
    this.height = 228,
    this.width = 375,
    this.scale = 1,
    this.loop = false,
    this.activeColor,
    this.normalColor,
    this.paginationMargin = const EdgeInsets.fromLTRB(0, 0, 0, 6),
    this.swiperPadding = EdgeInsets.zero,
    this.onClickListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: swiperPadding,
      height: height,
      width: width,
      child: Swiper(
          viewportFraction: viewportFraction,
          // 当前视窗展示比例 小于1可见上一个和下一个视窗
          scale: scale,
          // 两张图片之间的间隔
          scrollDirection: Axis.horizontal,
          // 横向
          itemCount: itemCount,
          // 数量
          loop: loop,
          // 无线轮播
          itemWidth: ScreenUtil().screenWidth, // 条目宽度
          itemHeight: ScreenUtil().screenHeight, // 条目高度
          autoplay: autoplay,
          // 自动翻页
          itemBuilder: itemBuilder,
          onTap: (index) {
            if (onClickListener == null) return;
            onClickListener!(index);
          },
          pagination: SwiperPagination(
            //圆点
            // 分页指示器
            alignment: Alignment.bottomCenter,
            // 位置 Alignment.bottomCenter 底部中间
            margin: paginationMargin,
            // 距离调整6
            builder: DotSwiperPaginationBuilder(
              activeColor: activeColor ?? const Color(0xFFDC593B),
              color: normalColor ?? const Color(0xFFF5F5F5),
              size: 6.w,
              activeSize: 6.w,
              space: 6.w,
            ),
          )),
    );
  }
}
