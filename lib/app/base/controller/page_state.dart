import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../model/enum.dart';

class PageState {
  final Rx<EmptyState> _emptyState = EmptyState.normal.obs;
  EmptyState get emptyState => _emptyState.value;
  set emptyState(value) => _emptyState.value = value;

  void showLoading() {
    emptyState = EmptyState.progress;
  }

  void showNormal() {
    emptyState = EmptyState.normal;
  }

  void showNetError() {
    emptyState = EmptyState.netError;
  }

  void showEmpty() {
    emptyState = EmptyState.empty;
  }
}
