import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, ImageByteFormat;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../common/utils/utils.dart';
import '../../widget/dialog.dart';

class PickResult {
  PickResult({
    this.filePath = '',
    this.thumbnailPath = '',
    this.image = true,
  });

  String filePath; //文件路径
  String thumbnailPath; //缩略图路径或者是视频封面路径
  bool image; //true: 图片资源，false: 视频资源

  factory PickResult.fromJson(Map<String, dynamic> json) => PickResult(
        filePath: json["filePath"],
        thumbnailPath: json["thumbnailPath"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "filePath": filePath,
        "thumbnailPath": thumbnailPath,
        "image": image,
      };
}

///相机、相册工具类
class PhotoCameraKit {
  static const List<String> allowedExtensions = [
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt',
  ];

  /// 相册
  static Future<List<AssetEntity>?> pickAlbum(
    BuildContext context, {
    int maxAssets = 9,
    RequestType requestType = RequestType.common,
  }) async {
    bool _request =
        await PermissionChecker.requestPhotoAlbumPermission(context);
    if (!_request) return null;
    return AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: maxAssets,
        requestType: requestType,
      ),
    );
  }

  ///拍摄
  ///[enableRecording] 是否允许录像
  static Future<AssetEntity?> camera(BuildContext context,
      {bool enableRecording = true}) async {
    bool _request = await PermissionChecker.requestCameraPermission(context);
    if (!_request) return null;
    final asset = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
        enableRecording: enableRecording,
        maximumRecordingDuration: const Duration(seconds: 15),
        shouldDeletePreviewFile: true,
        resolutionPreset: ResolutionPreset.high,
        textDelegate: CameraPickerText(),
      ),
    );
    return asset;
  }

  ///图片裁剪并上传
  static Future _cropAndUploadImage(
      BuildContext context, String imagePath, Function pickCallBack) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      compressQuality: 100,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: const Color(0xFFFD9558),
          toolbarTitle: 'photo_cut'.tr,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(minimumAspectRatio: 1.0),
      ],
    );
    pickCallBack(croppedFile);
  }

  ///图片压缩
  static Future<File?> compressAndGetFile(String originFilePath) async {
    if (originFilePath.isEmpty) return null;
    bool jpgFile = true;
    int lastIndex = originFilePath.lastIndexOf(RegExp(r'.jp'));
    if (lastIndex == -1) {
      jpgFile = false;
      lastIndex = originFilePath.lastIndexOf(RegExp(r'.png'));
    }
    final split = originFilePath.substring(0, (lastIndex));
    final outPath = '${split}_out${originFilePath.substring(lastIndex)}';
    File? result = await FlutterImageCompress.compressAndGetFile(
      originFilePath,
      outPath,
      quality: 60, //压缩百分比
      format: jpgFile ? CompressFormat.jpeg : CompressFormat.png,
    );
    return result;
  }

  static Future<Uint8List> compressWithList(
    Uint8List compressWithList, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
  }) async {
    return FlutterImageCompress.compressWithList(
      compressWithList,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );
  }

  ///选择弹窗
  ///[onPicked] item1: localFilePath, item2: localThumbnailFilePath
  static void showImagePicker(
    BuildContext context,
    ValueChanged<List<PickResult>> onPicked, {
    bool cropImage = false,
    int maxAssets = 1,
    bool enableRecording = false,
  }) {
    showBottomDialog(
      context,
      SizedBox(
        height: 160, //对话框高度就是此高度
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                _onClickPhotoOrCameraListener(context, false, onPicked,
                    cropImage: cropImage, enableRecording: enableRecording);
              },
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xFFF7F7FA)))),
                height: 50,
                child: Center(
                  child: Text(
                    'photo_shot'.tr,
                    style: const TextStyle(color: Color(0xFF262738)),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                _onClickPhotoOrCameraListener(
                  context,
                  true,
                  onPicked,
                  cropImage: cropImage,
                  maxAssets: maxAssets,
                  enableRecording: enableRecording,
                );
              },
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'photo_select'.tr,
                    style: const TextStyle(color: Color(0xFF262738)),
                  ),
                ),
              ),
            ),
            Container(
              height: 10,
              color: const Color(0xFFF7F7FA),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'cancel'.tr,
                    style: const TextStyle(color: Color(0xFF262738)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _onClickPhotoOrCameraListener(
    BuildContext context,
    bool photo,
    ValueChanged<List<PickResult>> onPicked, {
    bool cropImage = false,
    int maxAssets = 1,
    bool enableRecording = false,
  }) async {
    List<AssetEntity> assetEntityList = <AssetEntity>[];
    if (photo) {
      List<AssetEntity>? assetEntities = await pickAlbum(context,
          maxAssets: maxAssets,
          requestType:
              enableRecording ? RequestType.common : RequestType.image);
      assetEntityList = assetEntities ?? <AssetEntity>[];
    } else {
      AssetEntity? assetEntity =
          await camera(context, enableRecording: enableRecording);
      if (assetEntity != null) assetEntityList.add(assetEntity);
    }
    if (assetEntityList.isEmpty) return;
    List<PickResult> result = <PickResult>[];
    for (int i = 0; i < assetEntityList.length; i++) {
      bool image = assetEntityList[i].type == AssetType.image;
      File? file = await assetEntityList[i].file;
      if (file == null) return;
      if (image) {
        if (cropImage) {
          await _cropAndUploadImage(context, file.path,
              (CroppedFile? cropFile) {
            if (cropFile != null) file = File(cropFile.path);
          });
        }
        final thumbnail = await compressAndGetFile(file!.path);
        result.add(PickResult.fromJson({
          'filePath': file!.path,
          'thumbnailPath': thumbnail == null ? '' : thumbnail.path,
          'image': true,
        }));
      } else {
        final thumbnail = await VideoCompress.getFileThumbnail(file.path);
        result.add(PickResult.fromJson({
          'filePath': file.path,
          'thumbnailPath': thumbnail.path,
          'image': false,
        }));
      }
    }
    onPicked(result);
    Navigator.pop(context);
  }

  static Future<Uint8List?> getCaptureSource(GlobalKey repaintKey) async {
    try {
      RenderRepaintBoundary boundary = repaintKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      //see https://github.com/flutter/flutter/issues/21269
      ui.Image image =
          await boundary.toImage(pixelRatio: ScreenUtil().pixelRatio ?? 1);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('CreateFormulaPageState.getQrCodeSource $e');
    }
    return null;
  }

  ///保存截图
  /// return file path
  static Future<String?> saveScreenShotImage(
      BuildContext context, GlobalKey repaintKey) async {
    bool _request = await PermissionChecker.requestStoragePermission(context);
    if (!_request) return null;
    Uint8List? uint8List = await getCaptureSource(repaintKey);
    if (uint8List == null) return null;
    try {
      final result = await ImageGallerySaver.saveImage(uint8List, quality: 100);
      return result['filePath'];
    } catch (e) {
      return null;
    }
  }

  ///保存网络图片
  static Future<bool?> saveNetworkImage(String imageUrl) {
    return GallerySaver.saveImage(imageUrl);
  }
}

class CameraPickerText implements CameraPickerTextDelegate {
  @override
  String get confirm => 'camera_confirm'.tr;

  @override
  String get shootingTips => 'camera_shooting_tips'.tr;

  @override
  String get loadFailed => 'camera_load_failed'.tr;

  @override
  String get languageCode => LocaleUtil.getLocalLocale().languageCode;

  @override
  String get sActionManuallyFocusHint => 'camera_action_manually_focus_hint'.tr;

  @override
  String get sActionPreviewHint => 'camera_action_preview_hint'.tr;

  @override
  String get sActionRecordHint => 'camera_action_record_hint'.tr;

  @override
  String get sActionShootHint => 'camera_action_shoot_hint'.tr;

  @override
  String get sActionShootingButtonTooltip =>
      'camera_action_shooting_button_tooltip'.tr;

  @override
  String get sActionStopRecordingHint => 'camera_action_stop_recording_hint'.tr;

  @override
  String get shootingOnlyRecordingTips =>
      'camera_shooting_only_recording_tips'.tr;

  @override
  String get shootingTapRecordingTips =>
      'camera_shooting_tap_recording_tips'.tr;

  @override
  String get shootingWithRecordingTips =>
      'camera_shooting_with_recording_tips'.tr;

  @override
  String sCameraLensDirectionLabel(CameraLensDirection value) => value.name;

  @override
  String? sCameraPreviewLabel(CameraLensDirection? value) {
    if (value == null) {
      return null;
    }
    return '${sCameraLensDirectionLabel(value)} camera preview';
  }

  @override
  String sFlashModeLabel(FlashMode mode) => 'Flash mode: ${mode.name}';

  @override
  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) =>
      'Switch to the ${sCameraLensDirectionLabel(value)} camera';

  @override
  String get loading => 'loading';

  @override
  String get saving => 'saving';
}
