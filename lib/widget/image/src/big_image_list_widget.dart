import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '/common/utils/utils.dart';
import '/common/values/values.dart';
import '/widget/dashed_rect.dart';
import '/widget/wrap_widget.dart';
import '../image.dart';

class BigImageListWidget extends StatelessWidget {
  final String imageUrl; //图片地址
  final String thumbnailUrl; //缩略图地址
  final List<String> images; //多张图片切换
  final int currentIndex; //当前索引值
  final BoxConstraints? constraints;
  final void Function(int index)? callBack;

  const BigImageListWidget(
      {Key? key,
      required this.imageUrl,
      this.thumbnailUrl = '',
      this.images = const <String>[],
      this.currentIndex = 0,
      this.constraints,
      this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            barrierColor: Colors.black,
            builder: (context) {
              return ImageWidget(
                initIndex: currentIndex,
                thumbnailUrl: thumbnailUrl,
                imageUrl: imageUrl,
                images: images,
                callback: callBack,
              );
            });
      },
      child: SizedBox(
        width: constraints?.maxWidth ?? 90.w,
        height: constraints?.maxHeight ?? 90.w,
        child: PhotoCameraKit.isLocalFilePath(imageUrl)
            ? Image.file(
                File(imageUrl),
                fit: BoxFit.fill,
                width: constraints?.maxWidth ?? 90.w,
                height: constraints?.maxHeight ?? 90.w,
              )
            : loadImage(
                imageUrl,
                width: constraints?.maxWidth.w ?? 90.w,
                height: constraints?.maxHeight.w ?? 90.w,
              ),
      ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({
    Key? key,
    this.callback,
    this.initIndex = 0,
    required this.thumbnailUrl,
    this.images = const [],
    required this.imageUrl,
  }) : super(key: key);
  final void Function(int index)? callback;
  final int initIndex;
  final String thumbnailUrl; //缩略图地址
  final List<String> images; //多张图片切换
  final String imageUrl;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late PageController _pageController;
  var _currentIndex = 0;

  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initIndex);
    _currentIndex = widget.initIndex;
    _updateImages();
  }

  @override
  void didUpdateWidget(covariant ImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateImages();
  }

  void _updateImages() {
    _images = List.from(widget.images);
    if (_images.isEmpty) {
      _images.add(widget.imageUrl);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200.h,
            ),
            SizedBox(
              height: 375.h,
              child: PhotoViewGallery.builder(
                itemCount: _images.length,
                pageController: _pageController,
                enableRotation: true,
                builder: (context, index) {
                  String url = _images[index];
                  bool isLocalFile = PhotoCameraKit.isLocalFilePath(url);
                  ImageProvider localImageProvider = FileImage(File(url));
                  ImageProvider networkImageProvider =
                      CachedNetworkImageProvider(
                    url,
                    cacheKey: url,
                    cacheManager: DefaultCacheManager(),
                  );
                  return PhotoViewGalleryPageOptions(
                    imageProvider:
                        isLocalFile ? localImageProvider : networkImageProvider,
                    heroAttributes: const PhotoViewHeroAttributes(tag: "image"),
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    debugPrint('onPageChanged $_currentIndex');
                    _currentIndex = index;
                  });
                  if (widget.callback != null) {
                    widget.callback?.call(index);
                  }
                },
              ),
            ),
            SizedBox(
              height: 47.h,
            ),
            _buildBottomThumbnailImages()
          ],
        ),
        Positioned(
            top: 10.h,
            right: 10.w,
            child: InkWell(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    height: 50.w,
                    width: 50.w,
                    child: DashedRect(
                      color: const Color(0xFFA9A9B8),
                      strokeWidth: 1.w,
                      gap: 3.w,
                    ),
                  ),
                  getIconPng('ic_close', iconSize: 50.w)
                ],
              ),
              onTap: () {
                Get.back();
              },
            )),
      ],
    );
  }

  _buildBottomThumbnailImages() {
    debugPrint('_buildBottomThumbnailImages $_currentIndex ');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: WrapWidget(
        runSpacing: 10.w,
        children: map<Widget, String>(
          widget.images,
          (index, item) {
            bool select = (index == _currentIndex);
            return InkWell(
              onTap: () {
                _pageController.jumpToPage(index);
                if (widget.callback != null) {
                  widget.callback?.call(index);
                }
              },
              child: Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius5,
                  border: Border.all(
                      color: select ? const Color(0xFFEB4F27) : Colors.white,
                      width: 1.w),
                ),
                child: loadImage(item, width: 52.w, height: 52.w),
              ),
            );
          },
        ),
      ),
    );
  }
}
