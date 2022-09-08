import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'page_state.dart';

class PageStateController extends GetxController {
  final PageState pageState = PageState();

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
}
