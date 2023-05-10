import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

/// 内嵌的滚动列表可以与外部的滚动列表交互
class InnerScrollControllerWidget extends StatefulWidget {
  const InnerScrollControllerWidget({
    Key? key,
    this.controller,
    required this.child,
  }) : super(key: key);
  final ScrollController? controller;
  final Widget child;

  @override
  State<InnerScrollControllerWidget> createState() =>
      _InnerScrollControllerWidgetState();
}

class _InnerScrollControllerWidgetState
    extends State<InnerScrollControllerWidget> {
  late InnerScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = InnerScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScrollController oldScrollController = PrimaryScrollController.of(context);
    if (widget.controller != null) {
      oldScrollController = widget.controller!;
    }
    controller.updateParent(oldScrollController);
    controller.minExtent = 10.h;
  }

  @override
  void didUpdateWidget(covariant InnerScrollControllerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    var oldScrollController = PrimaryScrollController.of(context);
    controller.updateParent(widget.controller ?? oldScrollController);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
        controller: controller,
        child: KeyedSubtree(key: controller.key, child: widget.child));
  }
}

class InnerScrollController extends ScrollController {
  late ScrollController outerScrollCroller;
  final GlobalKey key = GlobalKey();

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    return InnerScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      innerScrollController: this,
      outerScrollCroler: outerScrollCroller,
    );
  }

  void updateParent(ScrollController parent) {
    outerScrollCroller = parent;
    for (var child in positions) {
      if (child is InnerScrollPosition) {
        child.outerScrollCroler = outerScrollCroller;
      }
    }
  }

  RevealedOffset? get revealedOffset {
    return RenderAbstractViewport.of(key.currentContext!.findRenderObject())
        .getOffsetToReveal(key.currentContext!.findRenderObject()!, 0);
  }

  Rect? showInScreen() {
    final object = key.currentContext!.findRenderObject()!;

    return RenderViewportBase.showInViewport(
      viewport: RenderAbstractViewport.of(object),
      offset: positions.last,
    );
  }

  double minExtent = 0;
}

typedef DeltaCallback = void Function(double delta);

class InnerScrollPosition extends ScrollPositionWithSingleContext {
  InnerScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    required this.outerScrollCroler,
    required this.innerScrollController,
    ScrollPosition? oldPosition,
  }) : super(physics: physics, context: context, oldPosition: oldPosition);

  ScrollController outerScrollCroler;
  final InnerScrollController innerScrollController;

  @override
  void applyUserOffset(double delta) {
    if (!outerScrollCroler.hasClients) {
      super.applyUserOffset(delta);
    } else {
      applyUserOffsetWithOuterPosition(delta, (delta) {
        super.applyUserOffset(delta);
        // ios 滚动适配
        if (pixels < minScrollExtent) {
          correctPixels(minScrollExtent);
        } else if (pixels > maxScrollExtent) {
          correctPixels(maxScrollExtent);
        }
      });
    }
  }

  void applyUserOffsetWithOuterPosition(double delta, DeltaCallback callback) {
    final position = outerScrollCroler.positions.last;
    final revealedOffset = innerScrollController.revealedOffset;
    if (revealedOffset != null) {
      final oldPixels = pixels;

      // 外部 Viewport 屏幕的像素区域
      final startPixels = position.pixels;
      final extent = position.viewportDimension;
      final endPixels = startPixels + extent;

      final targetHeight = revealedOffset.rect.height;
      var halfSpace = 0.0;
      if (extent > targetHeight) {
        halfSpace = (extent - targetHeight) / 2 - 10;
        halfSpace = math.max(halfSpace, 0.0);
      }
      // 目标 在 Viewport 中的区域位置
      final targetStartPixels = revealedOffset.offset;
      final targetEndPixels = targetStartPixels + targetHeight;

      if (delta < 0) {
        halfSpace -= 5;
        // 上拉
        if (startPixels >= targetStartPixels - halfSpace ||
            endPixels >= targetEndPixels + halfSpace) {
          callback(delta);
        }
      } else {
        halfSpace += 5;
        // 下拉
        if (startPixels <= targetStartPixels - halfSpace ||
            endPixels <= targetEndPixels + halfSpace) {
          callback(delta);
        }
      }

      var minScrollExtent = position.minScrollExtent;
      var maxScrollExtent = position.maxScrollExtent;

      var newPixels = (startPixels + (oldPixels - pixels) - delta)
          .clamp(minScrollExtent, maxScrollExtent);

      position.jumpTo(newPixels);
      return;
    }
    callback(delta);
  }

  @override
  void didOverscrollBy(double value) {
    return;
    // super.didOverscrollBy(value);
  }

  @override
  void beginActivity(ScrollActivity? newActivity) {
    _heldPreviousVelocity = 0.0;
    if (newActivity == null) return;
    assert(newActivity.delegate == this);
    super.beginActivity(newActivity);
    _currentDrag?.dispose();
    _currentDrag = null;
  }

  ScrollDragController? _currentDrag;

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    if (outerScrollCroler.hasClients) {
      final position = outerScrollCroler.positions.last;
      if (position is ScrollActivityDelegate) {
        final outerPosition = position as ScrollActivityDelegate;
        final delegate = DragDelegate(this, outerPosition);
        final ScrollDragController drag = ScrollDragController(
          delegate: delegate,
          details: details,
          onDragCanceled: dragCancelCallback,
          carriedVelocity: physics.carriedMomentum(_heldPreviousVelocity),
          motionStartDistanceThreshold:
              physics.dragStartDistanceMotionThreshold,
        );
        beginActivity(DragScrollActivity(this, drag));
        assert(_currentDrag == null);
        _currentDrag = drag;
        outerPosition.goIdle();
        return drag;
      }
    }
    return super.drag(details, dragCancelCallback);
  }

  double _heldPreviousVelocity = 0.0;

  @override
  ScrollHoldController hold(VoidCallback holdCancelCallback) {
    final double previousVelocity = activity!.velocity;
    final HoldScrollActivity holdActivity = HoldScrollActivity(
      delegate: this,
      onHoldCanceled: holdCancelCallback,
    );
    beginActivity(holdActivity);
    _heldPreviousVelocity = previousVelocity;
    return super.hold(holdCancelCallback);
  }

  @override
  void dispose() {
    _currentDrag?.dispose();
    _currentDrag = null;
    super.dispose();
  }
}

class DragDelegate implements ScrollActivityDelegate {
  DragDelegate(this.delegate, this.outerPosition);

  final InnerScrollPosition delegate;
  final ScrollActivityDelegate outerPosition;

  @override
  void applyUserOffset(double delta) {
    delegate.applyUserOffset(delta);
  }

  @override
  AxisDirection get axisDirection => delegate.axisDirection;

  @override
  void goBallistic(double velocity) {
    if (delegate.extentBefore == 0 && velocity < 0 ||
        delegate.extentAfter == 0 && velocity > 0) {
      outerPosition.goBallistic(velocity);
      if (delegate.outOfRange) {
        delegate.goBallistic(velocity);
      } else {
        goIdle();
      }
    } else {
      delegate.goBallistic(velocity);
    }
  }

  @override
  void goIdle() {
    delegate.goIdle();
  }

  @override
  double setPixels(double pixels) {
    return delegate.setPixels(pixels);
  }
}
