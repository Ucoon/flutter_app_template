import 'package:flutter/material.dart';
import '/app/base/base_body_widget.dart';
import '/app/base/controller/base_controller.dart';
import 'app_bar.dart';

class CommonLayoutPage<T extends BaseController> extends StatelessWidget {
  const CommonLayoutPage(
    this.body, {
    Key? key,
    this.title = '',
    this.margin = EdgeInsets.zero,
    this.appBarLeading,
    this.appBarBackgroundColor = Colors.white,
    this.backgroundColor = Colors.white,
    this.canBack = true,
    this.appBarElevation = 0,
    this.resizeToAvoidBottomInset = false,
    this.preferredHeight = 44,
    this.centerTitle = true,
    this.removeBottom = true,
    this.subTitle,
    this.titleIcon,
    this.appBarActions,
    this.onBack,
    this.footer,
    this.rootContext,
    this.onLeaveConfirm,
    this.bottom,
    this.emptyIcon,
    this.emptyText,
    this.netErrorIcon,
    this.onReload,
    this.loading,
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
  final PopInvokedWithResultCallback? onLeaveConfirm;
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
  final Widget? loading;

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
                  loading: loading,
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onLeaveConfirm,
      child: _buildBody(
        context,
        onBackConfirm: () async {
          onLeaveConfirm?.call(false, null);
        },
      ),
    );
  }
}
