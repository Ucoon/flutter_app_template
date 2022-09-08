import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget/easy_refresh/src/empty_result_widget.dart';
import '../../widget/loading_widget.dart';
import 'controller/base_controller.dart';
import 'model/enum.dart';

class BaseBodyWidget<T extends BaseController> extends GetWidget<T> {
  const BaseBodyWidget(
    this.body, {
    Key? key,
    this.loading,
    this.emptyIcon = 'ic_empty',
    this.emptyText = '',
    this.netErrorIcon = 'ic_net_error',
    this.onReload,
  }) : super(key: key);

  final Widget body;
  final Widget? loading;
  final String? emptyIcon;
  final String? emptyText;
  final String? netErrorIcon;
  final VoidCallback? onReload;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        EmptyState state = controller.pageState.emptyState;
        if (state == EmptyState.progress) {
          return loading ??
              const Center(
                child: LoadingWidget(
                  stop: false,
                ),
              );
        } else if (state == EmptyState.normal) {
          return body;
        } else if (state == EmptyState.empty) {
          return EmptyResultWidget(
            icon: emptyIcon ?? 'ic_empty',
            text: emptyText ?? '',
            showReload: false,
          );
        } else if (state == EmptyState.netError) {
          return EmptyResultWidget(
            icon: netErrorIcon ?? 'ic_net_error',
            text: emptyText ?? '',
            onReload: onReload,
            showReload: true,
          );
        }
        return body;
      },
    );
  }
}
