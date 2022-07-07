import 'package:kooboo_flutter_app_upgrade/flutter_app_upgrade.dart';

///应用内升级
class AppUpgradeKit {
  ///获取apk 下载路径(仅适用于Android)
  static Future<String> get apkDownloadPath {
    return FlutterAppUpgrade.apkDownloadPath;
  }

  ///安装apk(仅适用于Android)
  ///[path]: 'apkDownloadPath/downloadApkName';
  static installAppForAndroid(String path) {
    return FlutterAppUpgrade.installAppForAndroid(path);
  }

  ///跳转AppStore(仅适用于iOS)
  static goToAppStore(String id) {
    return FlutterAppUpgrade.goToAppStore(id);
  }

  ///跳转Google应用市场(仅适用于Android)
  static goToGoogleMarket() {
    return FlutterAppUpgrade.goToGoogleMarket();
  }
}
