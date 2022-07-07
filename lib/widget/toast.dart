import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> toastInfo({
  required String msg,
  Duration? duration,
  EasyLoadingToastPosition? toastPosition,
  EasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) async {
  EasyLoading.showToast(
    msg,
    duration: duration,
    toastPosition: toastPosition,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );
}

bool get isShow => EasyLoading.isShow;

void dismiss({animation = true}) {
  EasyLoading.dismiss(animation: animation);
}

void show({String status = '加载中...'}) {
  EasyLoading.show(status: status);
}
