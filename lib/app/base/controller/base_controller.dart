import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../http/http_error.dart';
import '../../../http/net_work.dart';
import '../../../widget/loading_dialog.dart';
import '../base_model.dart';
import 'page_state.dart';

class BaseController<T extends BaseModel> extends GetxController {
  final PageState pageState = PageState();
  late T model;
  BaseController(this.model);

  @override
  void onClose() {
    super.onClose();
    model.onClear();
  }

  void showLoading() {
    pageState.showLoading();
  }

  void showNormal() {
    pageState.showNormal();
  }

  void showNetError() {
    pageState.showNetError();
  }

  void showEmpty() {
    pageState.showEmpty();
  }

  void request<V>(
    Future<V> request,
    HttpSuccessCallback<V> success,
    HttpFailureCallback err, {
    bool showLoadingIndicator = true,
  }) {
    if (showLoadingIndicator) {
      showLoadingDialog();
    }
    request.catchError((onError) {
      if (showLoadingIndicator) {
        Get.back();
      }
      ///错误所有的网络异常
      debugPrint("啥错误:${onError.toString()}");
      HttpError error = HttpError.checkNetError(onError);
      error.handleError();
      err.call(error);
    }).then((value) {
      if (showLoadingIndicator) {
        Get.back();
      }
      success.call(value);
    });
  }
}
