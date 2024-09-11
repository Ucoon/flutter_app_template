import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// 动画模块
class FlowAnimatedWidget extends StatefulWidget {
  const FlowAnimatedWidget({
    Key? key,
    required this.child,
    required this.height,
    this.curve = Curves.easeInOut,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);
  final Widget child;
  final double height;
  final Curve curve;
  final Duration duration;

  @override
  State<FlowAnimatedWidget> createState() => _FlowAnimatedWidgetState();
}

class _FlowAnimatedWidgetState extends State<FlowAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    Future.delayed(const Duration(milliseconds: 300), run);
  }

  void run() {
    if (!mounted) return;
    controller.animateTo(
      1.0,
      curve: widget.curve,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _FlowAnimationWigdet(
          activedColor: const Color(0xFFEC6C3E),
          inactivedColor: const Color(0xFFC0C3C7),
          position: controller,
          horizontalBarHeight: 1.0.maxThan(widget.height * 0.42),
        ),
        widget.child,
      ],
    );
  }
}

/// 流程 renderBox
class _FlowAnimationWigdet extends LeafRenderObjectWidget {
  const _FlowAnimationWigdet({
    Key? key,
    this.position,
    this.activedColor = Colors.red,
    this.inactivedColor = const Color(0xFFEEEEEE),
    this.horizontalBarHeight = 5,
  }) : super(key: key);
  final Animation<double>? position;

  final Color activedColor;
  final Color inactivedColor;
  final double horizontalBarHeight;
  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderFlowAnimation(
      activedColor: activedColor,
      inactivedColor: inactivedColor,
      position: position,
      horizontalBarHeight: horizontalBarHeight,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderFlowAnimation renderObject) {
    renderObject
      ..position = position
      ..activedColor = activedColor
      ..inactivedColor = inactivedColor
      ..horizontalBarHeight = horizontalBarHeight;
  }
}

class _RenderFlowAnimation extends RenderBox {
  _RenderFlowAnimation({
    Animation<double>? position,
    Color activedColor = Colors.red,
    Color inactivedColor = Colors.grey,
    double horizontalBarHeight = 10,
  })  : _position = position,
        _activedColor = activedColor,
        _inactivedColor = inactivedColor,
        _horizontalBarHeight = horizontalBarHeight;
  Animation<double>? _position;
  Animation<double>? get position => _position;

  set position(Animation<double>? value) {
    if (_position != value) {
      _position?.removeListener(update);
      _position = value;
      _position?.addListener(update);
      markNeedsPaint();
    }
  }

  Color _activedColor;
  Color _inactivedColor;
  double _horizontalBarHeight;
  Color get activedColor => _activedColor;

  Color get inactivedColor => _inactivedColor;

  double get horizontalBarHeight => _horizontalBarHeight;

  set activedColor(Color color) {
    if (_activedColor != color) {
      _activedColor = color;
      markNeedsPaint();
    }
  }

  set inactivedColor(Color color) {
    if (_inactivedColor != color) {
      _inactivedColor = color;
      markNeedsPaint();
    }
  }

  set horizontalBarHeight(double value) {
    if (_horizontalBarHeight != value) {
      _horizontalBarHeight = value;
      markNeedsLayout();
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _position?.addListener(update);
  }

  void update() {
    markNeedsPaint();
  }

  @override
  void detach() {
    _position?.removeListener(update);
    super.detach();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  final clipLayer = LayerHandle<ClipRectLayer>();
  final clipLayerBackground = LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    clipLayer.layer = null;
    clipLayerBackground.layer = null;
    super.dispose();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  double computeMinIntrinsicHeight(double width) {
    return 30;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return 30;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return 120.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return 120.0;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final height = size.height;
    final width = size.width;
    final radius = height / 2;
    final fac = (position?.value ?? 1.0);
    final hideWidth = (width / 2 + radius - 0.8) * fac;
    clipLayerBackground.layer = context.pushClipRect(needsCompositing, offset,
        Offset(hideWidth * fac, 0) & Size(width, size.height), paintBackground,
        oldLayer: clipLayerBackground.layer);
    clipLayer.layer = context.pushClipRect(needsCompositing, offset,
        Offset.zero & Size(hideWidth, size.height), painter,
        oldLayer: clipLayer.layer);
  }

  void paintBackground(PaintingContext context, Offset offset) {
    painter(context, offset, color: inactivedColor);
  }

  void painter(PaintingContext context, Offset offset, {Color? color}) {
    color ??= activedColor;
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    final height = size.height;
    final width = size.width;
    final radius = height / 2;

    final paint = Paint()..color = color;

    final halfHeight = horizontalBarHeight / 2;
    final barOffsetY = .0.maxThan(radius - halfHeight);

    final rect =
        Rect.fromLTRB(radius, barOffsetY, width - radius, height - barOffsetY);
    canvas
      ..drawRect(rect, paint)
      ..drawCircle(Offset(radius, radius), radius, paint)
      ..drawCircle(Offset(width / 2, radius), radius, paint)
      ..drawCircle(Offset(width - radius, radius), radius, paint)
      ..restore();
  }
}

// 对齐实现
class FlowAlignWidget extends RenderObjectWidget {
  const FlowAlignWidget({
    Key? key,
    required this.leftChild,
    required this.centerChild,
    required this.rightChild,
    required this.followerHeight,
    required this.followerChild,
    this.maxCrossSpace = 0,
    this.maxSpace = 0,
    this.spaceAround = true,
  }) : super(key: key);
  final Widget leftChild;
  final Widget rightChild;
  final Widget centerChild;
  final Widget followerChild;
  final double followerHeight;
  final double maxSpace;
  final double maxCrossSpace;
  final bool spaceAround;

  @override
  RenderObjectElement createElement() {
    return FlowAlignElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFlowAlign(
      followerHeight: followerHeight,
      space: maxSpace,
      crossSpace: maxCrossSpace,
      spaceAround: spaceAround,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderFlowAlign renderObject) {
    renderObject
      ..space = maxSpace
      ..crossSpace = maxCrossSpace
      ..spaceAround = spaceAround
      ..followerHeight = followerHeight;
  }
}

class FlowAlignElement extends RenderObjectElement {
  FlowAlignElement(RenderObjectWidget widget) : super(widget);
  @override
  FlowAlignWidget get widget => super.widget as FlowAlignWidget;
  RenderFlowAlign get renderobject => super.renderObject as RenderFlowAlign;
  final children = <String, Element?>{};

  static const left = 'left';
  static const center = 'center';
  static const right = 'right';
  static const follower = 'follower';

  void updateAll() {
    _update(left, widget.leftChild);
    _update(center, widget.centerChild);
    _update(right, widget.rightChild);
    _update(follower, widget.followerChild);
  }

  void _update(String slot, Widget child) {
    try {
      children[slot] = updateChild(children[slot], child, slot);
    } catch (e) {
      children[slot] = null;
    }
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    updateAll();
  }

  @override
  void update(covariant RenderObjectWidget newWidget) {
    super.update(newWidget);
    updateAll();
  }

  @override
  void performRebuild() {
    super.performRebuild();
    updateAll();
  }

  @override
  void insertRenderObjectChild(
      covariant RenderBox child, covariant String slot) {
    renderobject.add(slot, child);
  }

  @override
  void removeRenderObjectChild(
      covariant RenderBox child, covariant String slot) {
    renderobject.remove(slot, child);
  }

  @override
  void visitChildElements(ElementVisitor visitor) {
    children.values.whereType<Element>().forEach(visitor);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    children.values.whereType<Element>().forEach(visitor);
  }

  @override
  void forgetChild(Element child) {
    final solt = child.slot as String;
    children.remove(solt);
    super.forgetChild(child);
  }

  @override
  void moveRenderObjectChild(covariant RenderObject child, covariant Object? oldSlot, covariant Object? newSlot) {
  }
}

class RenderFlowAlign extends RenderBox {
  RenderFlowAlign({
    double space = 0,
    double crossSpace = 0,
    bool spaceAround = true,
    required double followerHeight,
  })  : _space = space,
        _crossSpace = crossSpace,
        _spaceAround = spaceAround,
        _followerHeight = followerHeight;

  double _space;
  double get space => _space;
  set space(double value) {
    if (_space != value) {
      _space = value;
      markNeedsLayout();
    }
  }

  double _crossSpace;
  double get crossSpace => _crossSpace;
  set crossSpace(double value) {
    if (_crossSpace != value) {
      _crossSpace = value;
      markNeedsLayout();
    }
  }

  double _followerHeight;
  double get followerHeight => _followerHeight;

  set followerHeight(double value) {
    if (_followerHeight != value) {
      _followerHeight = value;
      markNeedsLayout();
    }
  }

  final _children = <String, RenderBox>{};

  void add(String slot, RenderBox child) {
    final oldChild = _children.remove(slot);
    if (oldChild != child) {
      if (oldChild != null) dropChild(oldChild);
      _children[slot] = child;
      adoptChild(child);
    }
  }

  void remove(String slot, RenderBox child) {
    final oldChild = _children.remove(slot);
    assert(child == oldChild);
    if (oldChild != null) {
      dropChild(oldChild);
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    for (var child in _children.values) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();
    for (var child in _children.values) {
      child.detach();
    }
    _children.clear();
  }

  @override
  void redepthChildren() {
    _children.values.forEach(redepthChild);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    _children.values.forEach(visitor);
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    _children.values.forEach(visitor);
  }

  RenderBox? get leftChild => _children[FlowAlignElement.left];
  RenderBox? get centerChild => _children[FlowAlignElement.center];
  RenderBox? get rightChild => _children[FlowAlignElement.right];
  RenderBox? get followerChild => _children[FlowAlignElement.follower];

  @override
  double computeMinIntrinsicWidth(double height) {
    final leftWidth = leftChild?.getMinIntrinsicWidth(height) ?? 0.0;
    final rightWidth = rightChild?.getMinIntrinsicWidth(height) ?? 0.0;
    final centerWidth = centerChild?.getMinIntrinsicWidth(height) ?? 0.0;
    final width = leftWidth +
        centerWidth +
        rightWidth +
        followerHeight +
        spaceCount * space;
    if (width.isFinite) {
      return width;
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return computeMinIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final leftHeight = leftChild?.getMinIntrinsicHeight(width) ?? 0.0;
    final centerHeight = centerChild?.getMinIntrinsicHeight(width) ?? 0.0;
    final rightHeight = rightChild?.getMinIntrinsicHeight(width) ?? 0.0;
    final height = width.minThan(
        leftHeight.maxThan(centerHeight).maxThan(rightHeight) + crossSpace);
    if (height.isFinite) {
      return height;
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    var leftSize = Size.zero;
    var centerSize = Size.zero;
    var rightSize = Size.zero;
    if (leftChild != null) {
      leftSize = leftChild!.getDryLayout(constraints);
    }
    if (centerChild != null) {
      centerSize = centerChild!.getDryLayout(constraints);
    }
    if (rightChild != null) {
      rightSize = rightChild!.getDryLayout(constraints);
    }

    var layoutWidth = leftSize.width +
        centerSize.width +
        rightSize.width +
        spaceCount * space;
    var layoutHeight =
        leftSize.height.maxThan(centerSize.height).maxThan(rightSize.height) +
            followerHeight;

    var width = constraints.constrainWidth(layoutWidth);
    var height = constraints.constrainHeight(layoutHeight);

    return Size(width, height);
  }

  bool _spaceAround;
  bool get spaceAround => _spaceAround;
  set spaceAround(bool value) {
    if (_spaceAround != value) {
      _spaceAround = value;
      markNeedsLayout();
    }
  }

  int get spaceCount {
    var count =
        [leftChild, centerChild, rightChild].whereType<RenderBox>().length;
    if (count > 0) {
      if (spaceAround) {
        count++;
      } else {
        count--;
      }
    }
    return count.maxThan(0);
  }

  @override
  void performLayout() {
    final childContraints = constraints.copyWith(
        minWidth: 0, maxWidth: constraints.maxWidth / 3 - 10);
    centerChild?.layout(childContraints, parentUsesSize: true);
    leftChild?.layout(childContraints, parentUsesSize: true);
    rightChild?.layout(childContraints, parentUsesSize: true);
    final leftSize = leftChild?.size ?? Size.zero;
    final centerSize = centerChild?.size ?? Size.zero;
    final rightSize = rightChild?.size ?? Size.zero;
    var leftRightMaxWidth = leftSize.width.maxThan(rightSize.width);

    // 取最大值
    final childrenMaxHeight =
        leftSize.height.maxThan(centerSize.height).maxThan(rightSize.height);
    // 加上跟随者的高度
    var height = childrenMaxHeight + followerHeight + crossSpace;
    height = constraints.constrainHeight(height);

    final followerAndCrossSpaceHeight = height - childrenMaxHeight;
    final realCrossSpace =
        .0.maxThan(followerAndCrossSpaceHeight - followerHeight);
    final realFollowerHeight = followerAndCrossSpaceHeight - realCrossSpace;

    var width = leftRightMaxWidth * 2 + centerSize.width;
    width = constraints.constrainWidth(width);
    final spaceCountLayout = spaceCount;

    var realSpace = space;
    final maxWidth = constraints.maxWidth;
    if (maxWidth.isFinite) {
      final allSpace = maxWidth - width;
      final itemSpace = allSpace / spaceCountLayout;
      // 不超出限制范围
      realSpace = realSpace.minThan(itemSpace);
    }
    leftRightMaxWidth = (width - centerSize.width) / 2;

    final followerContraints = BoxConstraints(
        maxWidth:
            width + realSpace * 2 - leftRightMaxWidth + realFollowerHeight,
        maxHeight: realFollowerHeight);

    followerChild?.layout(followerContraints, parentUsesSize: true);
    final followerSize = followerChild?.size ?? Size.zero;

    size = Size(width + realSpace * spaceCountLayout, height);
    // 两端是否要加空白
    var leftWhiteSpace = 0.0;
    if (spaceAround) {
      leftWhiteSpace = realSpace;
    }
    var offsetY = followerSize.height + realCrossSpace;

    final leftSpace = leftRightMaxWidth / 2 - leftSize.width / 2;

    if (followerChild != null) {
      final parentData = followerChild!.parentData as BoxParentData;
      parentData.offset = Offset(
          leftWhiteSpace + leftRightMaxWidth / 2 - followerSize.height / 2, 0);
    }

    if (leftChild != null) {
      final parentData = leftChild!.parentData as BoxParentData;
      parentData.offset = Offset(leftWhiteSpace + leftSpace,
          (childrenMaxHeight - leftSize.height) / 2 + offsetY);
    }
    if (centerChild != null) {
      final parentData = centerChild!.parentData as BoxParentData;
      parentData.offset = Offset(size.width / 2 - centerSize.width / 2,
          (childrenMaxHeight - centerSize.height) / 2 + offsetY);
    }
    if (rightChild != null) {
      final parentData = rightChild!.parentData as BoxParentData;
      final offsetX = size.width -
          leftWhiteSpace -
          leftRightMaxWidth / 2 -
          rightSize.width / 2;
      parentData.offset =
          Offset(offsetX, (childrenMaxHeight - rightSize.height) / 2 + offsetY);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void paintChild(RenderBox child) {
      final parentData = child.parentData as BoxParentData;
      context.paintChild(child, parentData.offset + offset);
    }

    if (leftChild != null) {
      paintChild(leftChild!);
    }
    if (centerChild != null) {
      paintChild(centerChild!);
    }
    if (rightChild != null) {
      paintChild(rightChild!);
    }
    if (followerChild != null) {
      paintChild(followerChild!);
    }
  }
}

extension<T extends num> on T {
  T maxThan(T other) {
    return math.max(this, other);
  }

  T minThan(T other) {
    return math.min(this, other);
  }
}
