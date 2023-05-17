import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '/widget/widget.dart';

class PermissionChecker {
  static Future<bool> check() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.microphone
    ].request();

    return !statuses.values.any((element) => !element.isGranted);
  }

  static Future<bool> requirePhotoAlbum() {
    return _request(photoAlbumPermission);
  }

  static Future<bool> openSettings() {
    return openAppSettings();
  }

  static Future<bool> _request(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  static Permission get photoAlbumPermission {
    return Platform.isIOS ? Permission.photos : Permission.storage;
  }

  ///请求相机权限
  static Future<bool> requestCameraPermission(BuildContext context) async {
    bool _granted = await Permission.camera.isGranted;
    if (_granted) return true;
    bool confirm = await showConfirm(
      context,
      '相机权限未开启，${'app_name'.tr}需要您的同意才能使用相机，相机用于拍摄您的用户头像',
    );
    if (!confirm) return false;
    bool _requestRes = await _request(Permission.camera);
    if (_requestRes) return true;
    PermissionChecker.openSettings();
    return false;
  }

  ///请求相册权限
  static Future<bool> requestPhotoAlbumPermission(BuildContext context) async {
    bool _granted = await photoAlbumPermission.isGranted;
    if (_granted) return true;
    bool confirm = await showConfirm(
      context,
      '无法访问相册中照片，${'app_name'.tr}需要您的同意才能访问您照片库中的照片，照片用于展示您的用户头像',
    );
    if (!confirm) return false;
    bool _requestRes = await _request(photoAlbumPermission);
    if (_requestRes) return true;
    PermissionChecker.openSettings();
    return false;
  }

  ///请求存储权限
  static Future<bool> requestStoragePermission(BuildContext context) async {
    bool _granted = await Permission.storage.isGranted;
    if (_granted) return true;
    bool confirm = await showConfirm(
      context,
      '存储权限未开启，${'app_name'.tr}需要您的同意才能使用存储，存储权限用于存储分享海报',
    );
    if (!confirm) return false;
    bool _requestRes = await _request(Permission.storage);
    if (_requestRes) return true;
    PermissionChecker.openSettings();
    return false;
  }

  ///请求通知栏权限
  ///请求存储权限
  static Future<bool> requestNotificationPermission(
      BuildContext context) async {
    bool _granted = await Permission.notification.isGranted;
    if (_granted) return true;
    bool confirm = await showConfirm(
      context,
      'notification_dialog_title'.tr,
      content: Text(
        'notification_dialog_content'.tr,
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF333333),
        ),
      ),
      falseLabel: 'forbid'.tr,
      trueLabel: 'allow'.tr,
    );
    if (!confirm) return false;
    bool _requestRes = await _request(Permission.notification);
    if (_requestRes) return true;
    PermissionChecker.openSettings();
    return false;
  }
}
