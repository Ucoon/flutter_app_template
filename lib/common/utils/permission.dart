import 'package:permission_handler/permission_handler.dart';

class PermissionChecker {
  static Future<bool> check() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.microphone
    ].request();

    return !statuses.values.any((element) => !element.isGranted);
  }

  static Future<bool> requireCamera() {
    return _check(Permission.camera);
  }

  static Future<bool> requireStorage(){
    return _check(Permission.storage);
  }

  static Future<bool> requireLocation(){
    return _check(Permission.location);
  }

  static Future<bool> openSettings() {
    return openAppSettings();
  }

  static Future<bool> requireNotification() {
    return _check(Permission.notification);
  }

  static Future<bool> requireContacts() {
    return _check(Permission.contacts);
  }

  static Future<bool> _check(Permission permission) async {
    final isGranted = await permission.isGranted;
    if (!isGranted) {
      final status = await permission.request();
      return status == PermissionStatus.granted;
    }
    return true;
  }
}
