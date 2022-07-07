import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../http/http_error.dart';
import '../../../http/net_work.dart';
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

  Future<void> launch(
    Future<void> Function() future,
    HttpFailureCallback err, {
    VoidCallback? finalCall,
    bool showLoadingIndicator = false,
    bool isCancelable = true,
  }) {
    return future().catchError((onError) {
      ///错误所有的网络异常
      debugPrint("啥错误:${onError.toString()}");
      HttpError error = HttpError.checkNetError(onError);
      if (error.code == RequestClient.tokenInValid.toString()) {
        ///TODO token过期处理
        return;
      }
      err.call(error);
      finalCall?.call();
    });
  }
}
