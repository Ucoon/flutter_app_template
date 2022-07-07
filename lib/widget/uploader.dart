import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/files.dart';
import 'package:get/get.dart';
import 'package:quiver/strings.dart';
import 'dashed_rect.dart';
import 'dialog.dart';
import 'image.dart';
import '../common/utils/utils.dart';

class ImageModel {
  final String localPreview;
  final String localThumbnailPreview;
  final String? pictureUrl;

  ImageModel(
    this.pictureUrl, {
    this.localPreview = '',
    this.localThumbnailPreview = '',
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['localPreview'] = localPreview;
    data['pictureUrl'] = pictureUrl;
    return data;
  }
}

///图片上传组件（默认展示添加图片）
class ImageUploaderWidget extends StatefulWidget {
  const ImageUploaderWidget(
    this.files, {
    Key? key,
    this.editable = false,
    this.onAdded,
    this.onDeleted,
    this.maxAssets = 1,
    this.enableRecording = false,
  }) : super(key: key);

  final bool editable;
  final int maxAssets;
  final bool enableRecording;
  final List<ImageModel> files;
  final ValueChanged<List<ImageModel>>? onAdded;
  final ValueChanged<ImageModel>? onDeleted;

  @override
  _ImageUploaderWidgetState createState() => _ImageUploaderWidgetState();
}

class _ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  List<ImageModel> _files = [];

  @override
  void initState() {
    super.initState();
    _files = widget.files;
  }

  @override
  void didUpdateWidget(covariant ImageUploaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.files != oldWidget.files) {
      _files = widget.files;
    }
  }

  Widget _renderImage(ImageModel it) {
    if (!isBlank(it.localPreview) && isLocalFilePath(it.localPreview)) {
      return Image.file(
        File(it.localPreview),
        fit: BoxFit.fill,
      );
    }
    return loadImage(
      it.pictureUrl ?? '',
      width: 70.w,
      height: 70.w,
    );
  }

  Widget _addBtn(BuildContext context) {
    if (!widget.editable) {
      return const SizedBox();
    }
    final btn = InkWell(
      onTap: () async {
        PhotoCameraKit.showImagePicker(
          context,
          (data) {
            for (var element in data) {
              ImageModel model = ImageModel(
                null,
                localPreview: element.filePath,
                localThumbnailPreview: element.thumbnailPath,
              );
              _files.add(model);
            }
            setState(() {});
            if (widget.onAdded == null) return;
            widget.onAdded!.call(_files);
          },
          maxAssets: widget.maxAssets,
          enableRecording: widget.enableRecording,
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
            height: 70.w,
            width: 70.w,
            child: DashedRect(
              color: const Color(0xFFA9A9B8),
              strokeWidth: 1.w,
              gap: 3.w,
            ),
          ),
          getIconPng('ic_camera', iconSize: 27.w)
        ],
      ),
    );
    if (widget.editable) {
      return Container(
        child: btn,
      );
    }
    return btn;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        ...map<Widget, ImageModel>(
          _files,
          (i, file) {
            final List<Widget> children = [];
            final img = Container(
              width: 70.w,
              height: 70.w,
              margin: EdgeInsets.only(right: 10.w),
              child: ClipRRect(
                child: _renderImage(file),
              ),
            );
            if (widget.editable) {
              children
                ..add(
                  Container(
                    child: img,
                  ),
                )
                ..add(
                  Positioned(
                    top: 0,
                    right: 6,
                    child: InkWell(
                        onTap: () async {
                          final confirm =
                              await showConfirm(context, 'delete_dialog'.tr);
                          final toRemove = _files[i];
                          if (confirm) {
                            setState(() {
                              _files.removeAt(i);
                            });
                            if (widget.onDeleted != null) {
                              widget.onDeleted!.call(toRemove);
                            }
                          }
                        },
                        child: Image.asset(
                          "assets/images/icon_cha2.png",
                          width: 18.w,
                          height: 18.w,
                        )),
                  ),
                );
            } else {
              children.add(img);
            }
            return Stack(
              children: children,
            );
          },
        ),
        _addBtn(context),
      ],
    );
  }
}
