import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_template/common/utils/utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '/widget/loading_widget.dart';

void showBigImageDialog(BuildContext context, {String imageUrl = ''}) {
  Get.to(
    AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: BigImageWidget(imageUrl: imageUrl),
    ),
  );
}

///大图预览
class BigImageWidget extends StatelessWidget {
  final String imageUrl; //图片地址
  BigImageWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key) {
    _isLocalFile = PhotoCameraKit.isLocalFilePath(imageUrl);
    _localImageProvider = FileImage(File(imageUrl));
    _networkImageProvider = CachedNetworkImageProvider(
      imageUrl,
      cacheKey: imageUrl,
      cacheManager: DefaultCacheManager(),
    );
  }
  late bool _isLocalFile;
  late ImageProvider _localImageProvider;
  late ImageProvider _networkImageProvider;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          PhotoView(
            imageProvider:
            _isLocalFile ? _localImageProvider : _networkImageProvider,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 42,
                ),
              );
            },
            loadingBuilder: (context, progress) {
              return const Center(
                child: LoadingWidget(
                  stop: false,
                ),
              );
            },
          ),
          Positioned(
            top: 38.h,
            left: 10.w,
            child: _buildLeadingWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingWidget() {
    return Container(
      alignment: Alignment.center,
      height: 44.h,
      width: 44.w,
      child: TextButton(
        child: Icon(
          Icons.arrow_back_ios_rounded,
          size: 24.w,
          color: Colors.white,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
