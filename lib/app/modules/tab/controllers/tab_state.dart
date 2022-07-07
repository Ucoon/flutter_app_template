import 'package:get/get.dart';

class TabState {
  // 当前 tab 页码
  final _page = 0.obs;
  set page(value) => _page.value = value;
  get page => _page.value;
}
