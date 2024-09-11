import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/common/utils/utils.dart';
import 'round_underline_tab_indicator.dart';

class TabOption {
  bool? active;
  dynamic key;
  String label = '';
  Widget? icon;
  TabOption(
    this.key,
    this.label, {
    this.active = false,
    this.icon,
  });

  TabOption.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    active = json['active'] ?? false;
    label = json['label'];
  }
}

class BottomTabBarView extends StatelessWidget implements PreferredSizeWidget {
  final List<TabOption> tabs;
  final double indicatorWeight;
  final double indicatorWidth;
  final double indicatorPaddingTop;
  final bool showIndicator;
  final ValueChanged<int>? tabChanged;
  final TabController? tabController;
  final EdgeInsetsGeometry? margin;
  final bool isScrollable;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Decoration? decoration;

  const BottomTabBarView({
    Key? key,
    required this.tabs,
    this.showIndicator = true,
    this.indicatorWeight = 4,
    this.indicatorWidth = 0,
    this.indicatorPaddingTop = 6,
    this.tabController,
    this.tabChanged,
    this.margin,
    this.isScrollable = false,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.decoration = const BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Color(0xFFF7F7F7),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: TabBar(
        onTap: tabChanged,
        isScrollable: isScrollable,
        tabs: map<Widget, TabOption>(
          tabs,
          (ix, it) {
            return Container(
              width:
                  isScrollable ? null : ScreenUtil().screenWidth / tabs.length,
              height: 50.h,
              padding: EdgeInsets.symmetric(
                horizontal: isScrollable ? 12.w : 0,
              ),
              decoration: decoration,
              alignment: Alignment.center,
              child: LayoutTextWithIconWidget(
                child: Text(
                  it.label,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                icon: it.icon ?? const SizedBox(),
              ),
            );
          },
        ),
        indicatorColor: const Color(0xFFD6A996),
        labelColor: labelStyle?.color ?? const Color(0xFFDC593B), //选中时文字颜色
        labelStyle: labelStyle ?? //选中时文字样式
            TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFFDC593B),
            ),
        unselectedLabelColor:
            unselectedLabelStyle?.color ?? const Color(0xFF757575),
        unselectedLabelStyle: unselectedLabelStyle ??
            TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF757575),
            ),
        indicator: showIndicator
            ? RoundUnderlineTabIndicator(
                borderSide: BorderSide(
                  width: indicatorWeight.w,
                  color: const Color(0xFFD6A996),
                ),
                indicatorWidth: indicatorWidth,
                indicatorPaddingTop: indicatorPaddingTop.h,
              )
            : const BoxDecoration(),
        labelPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.label,
        controller: tabController,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44.h);
}

class LayoutTextWithIconWidget extends RenderObjectWidget {
  const LayoutTextWithIconWidget({Key? key, required this.child, this.icon})
      : super(key: key);
  final Widget child;
  final Widget? icon;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _LayoutTextWithIconRenderObject();
  }

  @override
  RenderObjectElement createElement() {
    return _LayoutTextWithIconElement(this);
  }
}

class _LayoutTextWithIconElement extends RenderObjectElement {
  _LayoutTextWithIconElement(RenderObjectWidget widget) : super(widget);

  @override
  LayoutTextWithIconWidget get widget =>
      super.widget as LayoutTextWithIconWidget;

  @override
  _LayoutTextWithIconRenderObject get renderObject =>
      super.renderObject as _LayoutTextWithIconRenderObject;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    updateAll();
  }

  static const _icon = 'icon';
  static const _child = 'child';
  Element? child;
  Element? icon;

  @override
  void performRebuild() {
    super.performRebuild();
    updateAll();
  }

  @override
  void update(covariant RenderObjectWidget newWidget) {
    super.update(newWidget);
    updateAll();
  }

  void updateAll() {
    child = updateChild(child, widget.child, _child);
    icon = updateChild(icon, widget.icon, _icon);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (child != null) visitor(child!);
    if (icon != null) visitor(icon!);
  }

  @override
  void forgetChild(Element child) {
    final slot = child.slot;
    if (slot == _child) this.child = null;
    if (slot == _icon) icon = null;

    super.forgetChild(child);
  }

  @override
  void insertRenderObjectChild(
      covariant RenderBox child, covariant Object? slot) {
    renderObject.add(child, slot);
  }

  @override
  void removeRenderObjectChild(
      covariant RenderBox child, covariant Object? slot) {
    renderObject.remove(child, slot);
  }

  @override
  void moveRenderObjectChild(covariant RenderObject child, covariant Object? oldSlot, covariant Object? newSlot) {
  }
}

class _LayoutTextWithIconRenderObject extends RenderBox {
  RenderBox? child;
  RenderBox? icon;

  void add(RenderBox box, slot) {
    if (slot == _LayoutTextWithIconElement._child) {
      if (child != null) dropChild(child!);
      adoptChild(box);
      child = box;
    } else if (slot == _LayoutTextWithIconElement._icon) {
      if (icon != null) dropChild(icon!);
      adoptChild(box);
      icon = box;
    }
  }

  void remove(RenderBox box, slot) {
    if (slot == _LayoutTextWithIconElement._child) {
      if (child != null) dropChild(child!);
      child = null;
    } else if (slot == _LayoutTextWithIconElement._icon) {
      if (icon != null) dropChild(icon!);
      icon = null;
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (child != null) visitor(child!);
    if (icon != null) visitor(icon!);
  }

  @override
  void redepthChildren() {
    if (child != null) redepthChild(child!);
    if (icon != null) redepthChild(icon!);
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    if (child != null) child!.attach(owner);
    if (icon != null) icon!.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    if (child != null) child!.detach();
    if (icon != null) icon!.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    var childDrySize = Size.zero, iconDrySize = Size.zero;
    if (child != null) {
      childDrySize = child!.getDryLayout(constraints);
    }
    if (icon != null) {
      iconDrySize = icon!.getDryLayout(constraints);
    }
    final maxHeight = math.max(childDrySize.height, iconDrySize.height);

    return Size(childDrySize.width + iconDrySize.width, maxHeight);
  }

  @override
  void performLayout() {
    var iconSize = Size.zero;
    var childSize = Size.zero;

    if (icon != null) {
      icon!.layout(constraints.copyWith(minWidth: 0), parentUsesSize: true);
      iconSize = icon!.size;
    }
    if (child != null) {
      final m = constraints.maxWidth - iconSize.width;

      final childConstaints = icon == null
          ? constraints
          : constraints.copyWith(
              maxWidth: constraints.constrainWidth(m),
              minWidth: 0,
            );
      child!.layout(childConstaints, parentUsesSize: true);
      childSize = child!.size;
    }

    final maxHeight = math.max(childSize.height, iconSize.height);

    if (child != null) {
      final childParentData = child!.parentData as BoxParentData;
      childParentData.offset = Offset(0.0, (maxHeight - childSize.height) / 2);
    }
    if (icon != null) {
      final data = icon!.parentData as BoxParentData;
      data.offset = Offset(childSize.width, (maxHeight - iconSize.height) / 2);
    }
    final maxWidth = childSize.width + iconSize.width;
    size = Size(constraints.constrainWidth(maxWidth), maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, getChildOffset(child!) + offset);
    }
    if (icon != null) {
      context.paintChild(icon!, getChildOffset(icon!) + offset);
    }
  }

  Offset getChildOffset(RenderBox child) {
    return (child.parentData as BoxParentData).offset;
  }
}
