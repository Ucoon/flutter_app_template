import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_bar.dart';

class CommonLayoutPage extends StatelessWidget {
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
          child: body(rootContext ?? context),
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
