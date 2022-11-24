import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/base/base_body_widget.dart';
import '../../../../app/base/controller/base_controller.dart';
import 'app_bar.dart';

class CommonLayoutPage<T extends BaseController> extends StatelessWidget {
  const CommonLayoutPage(
    this.body, {
    Key? key,
    this.title = '',
    this.subTitle,
    this.titleIcon,
    this.appBarActions,
    this.margin = EdgeInsets.zero,
    this.appBarLeading,
    this.appBarBackgroundColor = Colors.white,
    this.backgroundColor = Colors.white,
    this.onBack,
    this.footer,
    this.rootContext,
    this.appBarElevation = 0,
    this.resizeToAvoidBottomInset = false,
    this.onLeaveConfirm,
    this.canBack = true,
    this.bottom,
    this.preferredHeight = 44,
    this.centerTitle = true,
    this.removeBottom = true,
    this.emptyIcon,
    this.emptyText,
    this.netErrorIcon,
    this.onReload,
  }) : super(key: key);

  final Widget Function(BuildContext ctx) body;
  final Widget Function()? appBarLeading;
  final List<Widget>? appBarActions;
  final double appBarElevation;
  final Color backgroundColor;
  final Color appBarBackgroundColor;
  final Widget? footer;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onBack;
  final WillPopCallback? onLeaveConfirm;
  final bool resizeToAvoidBottomInset;
  final BuildContext? rootContext;
  final String title;
  final Widget? subTitle;
  final Widget? titleIcon;
  final bool canBack;
  final PreferredSizeWidget? bottom;
  final double preferredHeight;
  final bool centerTitle;
  final bool removeBottom;
  final String? emptyIcon;
  final String? emptyText;
  final String? netErrorIcon;
  final VoidCallback? onReload;

  Widget _buildBody(BuildContext context, {VoidCallback? onBackConfirm}) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(
        rootContext ?? context,
        title,
        subTitle: subTitle,
        titleIcon: titleIcon,
        actions: appBarActions,
        leading: canBack ? appBarLeading?.call() : null,
        onBackClick: onBack ?? onBackConfirm,
        elevation: appBarElevation,
        backgroundColor: appBarBackgroundColor,
        canBack: canBack,
        bottom: bottom,
        preferredHeight: preferredHeight,
        centerTitle: centerTitle,
      ),
      body: SafeArea(
        bottom: removeBottom,
        child: Container(
          color: backgroundColor,
          margin: margin,
          child: BaseBodyWidget<T>(
            body(rootContext ?? context),
            emptyIcon: emptyIcon,
            emptyText: emptyText,
            netErrorIcon: netErrorIcon,
            onReload: onReload,
          ),
        ),
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: footer,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (onLeaveConfirm == null) {
      return _buildBody(context);
    }

    return WillPopScope(
      child: _buildBody(
        context,
        onBackConfirm: () async {
          final confirm = await onLeaveConfirm!();
          if (confirm) {
            Get.back();
          }
        },
      ),
      onWillPop: onLeaveConfirm,
    );
  }
}
