import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiver/strings.dart';

///图片加载工具类
Widget loadImage(
  String url, {
  double? width = 64,
  double? height = 64,
  BoxFit fit = BoxFit.cover,
  Color? imageColor,
  BlendMode? colorBlendMode,
  bool darkLoading = false,
  double? loadingSize,
  Alignment? alignment,
  Color? color,
  String placeholder = 'icon_place_logo',
}) {
  if (isBlank(url)) {
    return getDefaultPlaceHolderWidget(
        width: width ?? 64, height: height ?? 64);
  }
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
    color: imageColor,
    colorBlendMode: colorBlendMode,
    cacheKey: url,
    alignment: alignment ?? Alignment.center,
    cacheManager: DefaultCacheManager(),
    placeholder: (context, url) {
      return getDefaultPlaceHolderWidget(
          width: width ?? 64, height: height ?? 64);
    },
    errorWidget: (context, url, error) {
      return getDefaultPlaceHolderWidget(
          width: width ?? 64, height: height ?? 64);
    },
  );
}

Widget getDefaultPlaceHolderWidget({
  double width = 64,
  double height = 64,
  String placeholder = 'icon_place_logo',
}) {
  return Container(
    width: width,
    height: height,
    color: const Color(0xFFE0E2E6),
    alignment: Alignment.center,
    child: Image.asset(
      'assets/images/$placeholder.png',
    ),
  );
}

Widget getIconByPackageName(
  url, {
  double width = 64,
  double height = 64,
  String suffix = 'png',
  String? packageName,
}) {
  return Image.asset(
    'assets/images/$url.$suffix',
    width: width.w,
    height: height.h,
    fit: BoxFit.cover,
    package: packageName,
  );
}

CachedNetworkImageProvider getCacheNetworkImageProvider(String imageUrl) =>
    CachedNetworkImageProvider(
      imageUrl,
      cacheKey: imageUrl,
      cacheManager: DefaultCacheManager(),
    );

Widget getIconPng(
  String url, {
  double iconSize = 64.0,
}) {
  return getIcon(url, "png", iconSize: iconSize.w);
}

Widget getIconJpg(String url, {double iconSize = 64.0}) {
  return getIcon(url, "jpg", iconSize: iconSize.w);
}

Widget getIcon(String url, String suffix, {double iconSize = 64.0}) {
  return Image.asset(
    'assets/images/$url.$suffix',
    width: iconSize,
    height: iconSize,
    // fit: BoxFit.cover,
  );
}

Widget getIconPngWithSize(String url,
    {double? width = 64, double? height = 64, BoxFit? fit}) {
  return getIconWithSize(url, 'png', width: width, height: height, fit: fit);
}

Widget getIconWithSize(String url, String suffix,
    {double? width = 64, double? height = 64, BoxFit? fit}) {
  return Image.asset(
    'assets/images/$url.$suffix',
    width: width,
    height: height,
    fit: fit,
    // fit: BoxFit.cover,
  );
}

AssetImage getAssetImage(
  String url, {
  String suffix = 'png',
}) {
  return AssetImage('assets/images/$url.$suffix');
}
