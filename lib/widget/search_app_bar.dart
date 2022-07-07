import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'image.dart';
import 'layout/layout.dart';

/// 带搜索功能的AppBar
PreferredSizeWidget buildSearchAppBar({
  String? placeholder,
  bool canBack = true,
  FocusNode? focusNode,
  TextEditingController? textEditingController,
  Function(String keyword)? onChange,
  required Function(String keyword) onSubmitted,
  List<Widget> actions = const <Widget>[],
  int maxLength = 20,
  Decoration? decoration,
  Color? backgroundColor,
  TextStyle? style,
  double? cursorWidth,
  Radius? cursorRadius,
  Color? cursorColor,
  double? rightMargin,
}) {
  placeholder ??= 'search_hint'.tr;
  return SearchAppBarWidget(
    rightMargin: rightMargin,
    controller: textEditingController ?? TextEditingController(),
    focusNode: focusNode ?? FocusNode(),
    elevation: 0,
    searchBoxPadding: 10.h,
    canBack: canBack,
    actions: actions,
    decoration: decoration,
    style: style,
    cursorWidth: cursorWidth,
    cursorColor: cursorColor,
    cursorRadius: cursorRadius,
    inputFormatters: [
      LengthLimitingTextInputFormatter(
        maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
      ),
    ],
    hintText: placeholder,
    onChange: onChange,
    onSubmitted: (value) {
      onSubmitted(value);
      focusNode?.unfocus();
    },
  );
}

class SearchAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final double preferredHeight;
  // final double height;
  final double elevation; //阴影
  final bool canBack; //是否显示返回按钮
  final Widget? leading;
  final String hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final List<Widget> actions;
  final void Function(String)? onChange;
  final void Function(String)? onSubmitted;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;
  final ShapeBorder? shape;
  final GestureTapCallback? onTap;
  final double? rightMargin;
  final Decoration? decoration;
  final TextStyle? style;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final double searchBoxPadding;
  final bool removeTop;
  final String? initValue;
  SearchAppBarWidget({
    Key? key,
    // this.preferredHeight = 44.0,
    // this.height = 32.0,
    this.elevation = 0.5,
    this.leading,
    this.toolbarHeight = kToolbarHeight,
    this.canBack = true,
    required this.hintText,
    this.initValue,
    this.focusNode,
    this.controller,
    this.inputFormatters,
    this.onChange,
    this.onSubmitted,
    this.actions = const <Widget>[],
    this.rightMargin,
    this.bottom,
    this.shape,
    this.onTap,
    this.prefixIcon,
    this.decoration,
    this.style,
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth,
    this.removeTop = true,
    this.searchBoxPadding = 0.0,
  })  : preferredHeight = toolbarHeight + (bottom?.preferredSize.height ?? 0),
        super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    assert(toolbarHeight > 12.h + searchBoxPadding || searchBoxPadding >= -12.h,
        '搜索框有额外的margin');
    final halfPadding = searchBoxPadding / 2;
    final top = removeTop ? MediaQuery.of(context).padding.top : 0.0;
    return Stack(
      children: <Widget>[
        buildAppBar(
          context,
          '',
          canBack: false,
          backgroundColor: Colors.white,
          toolbarHeight: toolbarHeight,
          bottom: bottom,
          shape: shape,
        ),
        Row(
          children: [
            if (leading != null) leading!,
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: 6.h + halfPadding, top: halfPadding + top),
                child: SearchInputWidget(
                  height: toolbarHeight - 12.h - searchBoxPadding,
                  hasLeading: false,
                  hasActions: actions.isNotEmpty,
                  rightMargin: 0,
                  hintText: hintText,
                  initValue: initValue,
                  focusNode: focusNode,
                  controller: controller,
                  prefixIcon: prefixIcon,
                  inputFormatters: inputFormatters,
                  onChange: onChange,
                  onSubmitted: onSubmitted,
                  onTap: onTap,
                  decoration: decoration,
                  style: style,
                  cursorWidth: cursorWidth,
                  cursorColor: cursorColor,
                  cursorRadius: cursorRadius,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: actions,
              ),
            )
          ],
        )
      ],
    );
  }
}

class SearchInputWidget extends StatefulWidget {
  final double height;
  final bool hasLeading;
  final bool hasActions;
  final String hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final double? leftMargin;
  final double? rightMargin;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChange;
  final GestureTapCallback? onTap;
  final Decoration? decoration;
  final TextStyle? style;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final String? initValue;

  SearchInputWidget({
    Key? key,
    this.height = 32.0,
    this.hasLeading = true,
    this.hasActions = true,
    String? hintText,
    this.initValue,
    this.focusNode,
    this.controller,
    this.inputFormatters,
    this.onChange,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.leftMargin,
    this.rightMargin,
    this.decoration,
    this.style,
    this.cursorWidth,
    this.cursorRadius,
    this.cursorColor,
  })  : hintText = hintText ?? 'search_hint_default'.tr,
        super(key: key);

  @override
  State<SearchInputWidget> createState() => _SearchInputWidgetState();
}

class _SearchInputWidgetState extends State<SearchInputWidget> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.initValue);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: widget.leftMargin ?? (widget.hasLeading ? 48.w : 12.w),
          right: widget.hasActions ? widget.rightMargin ?? 48.w : 12.w,
          top: 6.h,
          bottom: 0.h,
        ),
        child: Container(
          height: widget.height,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: widget.decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2.0.r)),
                color: const Color(0xFFF0F0F0),
              ),
          child: TextField(
            enabled: widget.onTap == null,
            focusNode: widget.focusNode,
            style: widget.style,
            cursorWidth: widget.cursorWidth ?? 2.w,
            cursorColor: widget.cursorColor,
            cursorRadius: widget.cursorRadius,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            controller: controller,
            maxLines: 1,
            inputFormatters: widget.inputFormatters,
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFFC0C1C4),
                ),
                prefixIconConstraints: BoxConstraints(
                    minWidth: widget.prefixIcon == null ? 10.w : 32.w),
                prefixIcon: widget.prefixIcon ?? const SizedBox(),
                suffix: InkWell(
                  onTap: () {
                    controller.text = '';
                  },
                  child: Transform.translate(
                    offset: Offset(0, 2.h),
                    child: getIconPng(
                      'ic_input_clear',
                      iconSize: 14.w,
                    ),
                  ),
                ),
                isDense: true,
                fillColor: Colors.transparent,
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
            onChanged: widget.onChange,
            onSubmitted: widget.onSubmitted,
          ),
        ),
      ),
    );
  }
}
