import 'package:kooboo_flutter_app_upgrade/flutter_app_upgrade.dart';

///应用内升级
class AppUpgradeKit {
  ///下载并安装apk(仅适用于Android)
  static downloadApkInstall(String downloadUrl, String versionName) async {
    return FlutterAppUpgrade.downloadApkInstall(downloadUrl, versionName);
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
