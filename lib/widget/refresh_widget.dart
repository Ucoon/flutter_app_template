import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'loading_widget.dart';

RunningDelegate buildDefaultRefresh(
  FutureOr<void> Function()? onRunning, {
  Alignment alignment = const Alignment(0, -0.5),
}) {
  return RunningDelegate(
      maxExtent: 120.h,
      onRunning: onRunning,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      builder: (context, offset, maxExtent, mode, running, success) {
        if (mode == RefreshLoadingMode.idle) return const SizedBox();
        late final Widget child;
        if (success) {
          child = Text('refresh_success'.tr);
        } else if (running) {
          child = Text('refreshing'.tr);
        } else {
          switch (mode) {
            case RefreshLoadingMode.running:
              child = Text('refreshing'.tr);
              break;
            case RefreshLoadingMode.done:
              child = Text('refresh_done'.tr);
              break;
            case RefreshLoadingMode.ignore:
              child = Text('refresh_cancel'.tr);
              break;
            case RefreshLoadingMode.dragEnd:
              child = Text('refresh_release'.tr);
              break;
            case RefreshLoadingMode.dragStart:
            case RefreshLoadingMode.idle:
              child = Text('refresh_drag'.tr);
              break;
            case RefreshLoadingMode.failed:
              child = Text('refresh_failed'.tr);
              break;
            default:
          }
        }
        final stop = !running &&
            !success &&
            (mode.index < RefreshLoadingMode.running.index ||
                mode == RefreshLoadingMode.ignore);

        return RepaintBoundary(
          child: Align(
            alignment: alignment,
            child: ClipRect(
              child: OverflowBar(
                overflowAlignment: OverflowBarAlignment.center,
                children: [
                  LoadingWidget(
                    stop: stop,
                    progress: (maxExtent - 36 - offset) / (maxExtent * 2),
                  ),
                  child,
                ],
              ),
            ),
          ),
        );
      });
}

RunningDelegate buildDefaultLoading(void Function()? onDragStart) {
  return RunningDelegate(
      maxExtent: 80.h,
      onDragStart: onDragStart,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      builder: (context, offset, maxExtent, mode, running, success) {
        if (mode == RefreshLoadingMode.idle) return const SizedBox();
        late final Widget child;
        if (success) {
          child = Text('load_done'.tr);
        } else if (running) {
          child = Text('loading'.tr);
        } else {
          switch (mode) {
            case RefreshLoadingMode.done:
              child = Text('load_done'.tr);
              break;
            case RefreshLoadingMode.running:
            case RefreshLoadingMode.ignore:
            case RefreshLoadingMode.dragEnd:
            case RefreshLoadingMode.dragStart:
            case RefreshLoadingMode.idle:
              child = Text('loading'.tr);
              break;
            case RefreshLoadingMode.failed:
              child = Text('load_failed'.tr);
              break;
            default:
          }
        }
        return RepaintBoundary(
          child: Align(
            alignment: const Alignment(0, -0.5),
            child: ClipRect(
              child: OverflowBar(
                overflowAlignment: OverflowBarAlignment.center,
                children: [
                  const LoadingWidget(
                    stop: false,
                  ),
                  child,
                ],
              ),
            ),
          ),
        );
      });
}

/// 不支持嵌入[NestedScrollView]
class Refresh extends StatefulWidget {
  const Refresh({
    Key? key,
    this.refresh,
    this.loading,
    required this.slivers,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.emptyWidget,
    this.preLoad,
  }) : super(key: key);

  final List<Widget> slivers;
  final RunningDelegate? refresh;
  final RunningDelegate? loading;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? scrollController;
  final bool? primary;
  final Key? center;
  final double anchor;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final Widget? emptyWidget;
  final Future<void> Function()? preLoad;

  @override
  State<Refresh> createState() => _RefreshState();
}

class _RefreshState extends State<Refresh> {
  late _RefreshBase refresh;
  late _RefreshBase loading;
  @override
  void initState() {
    super.initState();
    refresh = _Refresh().._setDelegate(widget.refresh);
    loading = _Loading().._setDelegate(widget.loading);
    widget.scrollController?.addListener(_listen);
  }

  @override
  void didUpdateWidget(covariant Refresh oldWidget) {
    super.didUpdateWidget(oldWidget);
    refresh._setDelegate(widget.refresh);
    loading._setDelegate(widget.loading);
    oldWidget.scrollController?.removeListener(_listen);
    widget.scrollController?.addListener(_listen);
  }

  Future<void>? _task;
  void _listen() {
    final controller = widget.scrollController;
    if (controller != null && controller.hasClients) {
      final position = controller.position;
      if (position.maxScrollExtent <= position.pixels + 80.h) {
        if (_task == null && widget.preLoad != null) {
          _task = widget.preLoad!();
          _task!.whenComplete(() => _task = null);
        }
      }
    }
  }

  @override
  void dispose() {
    refresh._setDelegate(null);
    loading._setDelegate(null);
    widget.scrollController?.removeListener(_listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _slivers = List.of(widget.slivers);
    if (_slivers.isEmpty) {
      _slivers.add(SliverToBoxAdapter(child: widget.emptyWidget));
    }
    if (refresh.runningDelegate != null) {
      _slivers.insert(
        0,
        SliverToBoxAdapter(
          child: RepaintBoundary(
              child: _RefreshLoadingWidget(refreshBase: refresh)),
        ),
      );
    }
    if (loading.runningDelegate != null) {
      /// 自动填充空白区域
      _slivers.add(
          const SliverFillRemaining(hasScrollBody: false, child: SizedBox()));
      _slivers.add(
        SliverToBoxAdapter(
          child: RepaintBoundary(
              child: _RefreshLoadingWidget(refreshBase: loading)),
        ),
      );
    }

    var child = NotificationListener(
        onNotification: _onNotification,
        child: CustomScrollView(
          slivers: _slivers,
          dragStartBehavior: widget.dragStartBehavior,
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          controller: widget.scrollController,
          primary: widget.primary,
          center: widget.center,
          anchor: widget.anchor,
          cacheExtent: widget.cacheExtent,
          semanticChildCount: widget.semanticChildCount,
          // emptyWidget: widget.emptyWidget,
        ));

    final behavior = ScrollConfiguration.of(context);
    final physics = ClampBouncingScrollPhysics(refresh, loading,
        parent: behavior.getScrollPhysics(context));
    return ScrollConfiguration(
      behavior: behavior.copyWith(physics: physics),
      child: child,
    );
  }

  bool _onNotification(Notification n) {
    if (loading.onNotifition(n)) {
      if (n is OverscrollIndicatorNotification) {
        if (n.leading) n.disallowIndicator();
      }
      return false;
    }
    refresh.onNotifition(n);
    return false;
  }
}

/// 所有状态都是临时状态
/// 永久性的状态 [running], [success]会额外给出，如在回调的参数中
enum RefreshLoadingMode {
  // --- 空闲状态
  idle,
  // --- 拖动过程
  dragStart,
  draging,
  dragEnd,
  // --- 释放刷新
  running,
  // --- 完成刷新
  done,
  // --- 拖动取消
  ignore,
  // --- 动画
  animatedIgnore,
  animatedDone,
  // --- 失败
  failed, // 如果用户还在接管手势，则可能还会调用onRunning;
}

extension RefreshLoadingModeActive on RefreshLoadingMode {
  bool get active {
    return this == RefreshLoadingMode.running ||
        this == RefreshLoadingMode.done ||
        this == RefreshLoadingMode.animatedDone;
  }

  RefreshLoadingMode get outerMode {
    RefreshLoadingMode mode = this;
    switch (this) {
      case RefreshLoadingMode.animatedDone:
        mode = RefreshLoadingMode.done;
        break;
      case RefreshLoadingMode.animatedIgnore:
        mode = RefreshLoadingMode.ignore;
        break;
      case RefreshLoadingMode.draging:
        mode = RefreshLoadingMode.dragStart;
        break;
      case RefreshLoadingMode.idle:
      case RefreshLoadingMode.dragStart:
      case RefreshLoadingMode.dragEnd:
      case RefreshLoadingMode.running:
      case RefreshLoadingMode.done:
      case RefreshLoadingMode.ignore:
      case RefreshLoadingMode.failed:
        mode = this;
        break;
    }
    return mode;
  }
}

typedef OnRunning = FutureOr<void> Function();

typedef RefreshLoadingBuilder = Widget Function(
    BuildContext context,
    double offset,
    double maxExtent,
    RefreshLoadingMode mode,
    bool running,
    bool success);

class RunningDelegate {
  RunningDelegate({
    this.onDragStart,
    this.onDragEnd,
    this.onDragIgnore,
    this.onDone,
    this.onRunning,
    this.waitingOnDone = const Duration(milliseconds: 800),
    this.maxDurationOnRunning = const Duration(milliseconds: 1500),
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    required this.maxExtent,
    required this.builder,
  }) : assert(maxExtent > 0.0);
  final VoidCallback? onDragStart;

  /// 当拖动距离达到[maxExtent]调用
  final VoidCallback? onDragEnd;
  final VoidCallback? onDragIgnore;
  final VoidCallback? onDone;
  final OnRunning? onRunning;
  final RefreshLoadingBuilder builder;
  final double maxExtent;
  final RefreshIndicatorTriggerMode triggerMode;
  final Duration waitingOnDone;
  final Duration maxDurationOnRunning;

  /// 生命周期自动设置
  _RefreshBase? _refresh;
  BuildContext? _context;

  void show() {
    if (_context != null && _refresh != null) {
      final position = Scrollable.of(_context!).position;
      position.jumpTo(position.minScrollExtent);
      _refresh!
        .._setValue(maxExtent)
        .._setMode(RefreshLoadingMode.running);
    }
  }

  void hide() {
    _refresh?._setValue(0.0);
  }

  void refreshLoadingFailed() {
    _refresh?._setMode(RefreshLoadingMode.failed);
  }
}

class _Refresh extends _RefreshBase {
  @override
  bool getCanLoading(ScrollStartNotification n) {
    return n.metrics.extentBefore == 0;
  }

  @override
  void onOverScroll(OverscrollNotification n) {
    final mes = n.metrics;

    final isAtEdge = mes.extentBefore == 0.0;
    final overscroll = n.overscroll;
    // print('...... $overscroll | $isAtEdge | $value');
    if (overscroll < 0 || (isAtEdge && value > 0.0)) {
      final newValue = (value - overscroll).clamp(0.0, maxExtent);

      _setValue(newValue);
    }
  }

  @override
  void onScrollUpdate(ScrollUpdateNotification n) {
    final scrollDelta = n.scrollDelta;
    if (scrollDelta != null) {
      final mes = n.metrics;
      if (n.dragDetails == null) {
        // return;
      }
      if ((value > 0.0) && (scrollDelta > 0 || mes.extentBefore == 0.0)) {
        final newValue = (value - scrollDelta).clamp(0.0, maxExtent);
        Scrollable.of(n.context!).position.correctBy(-scrollDelta);
        _setValue(newValue);
      }
    }
  }

  @override
  void onOverScrollIndicator(OverscrollIndicatorNotification n) {
    if (n.leading) {
      n.disallowIndicator();
    }
  }
}

class _Loading extends _RefreshBase {
  @override
  bool getCanLoading(ScrollStartNotification n) {
    return n.metrics.extentAfter == 0;
  }

  @override
  void onOverScroll(OverscrollNotification n) {
    final mes = n.metrics;
    // if (n.dragDetails == null) return;
    final isAtEdge = mes.extentAfter == 0.0;
    final overscroll = n.overscroll;
    // print('......onOverScroll $overscroll | $isAtEdge | $value');
    if (overscroll > 0 || (isAtEdge && value > 0.0)) {
      final oldValue = value;
      final newValue = (value + overscroll).clamp(0.0, maxExtent);
      _setValue(newValue);
      // assert(() {
      //   // 在帧后回调中检查
      //   SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      //     final position = Scrollable.of(n.context!)?.position;
      //     print('.... ${position?.pixels}  ${position?.maxScrollExtent}');
      //   });
      //   return true;
      // }());
      final delta = value - oldValue;
      // loading widget 的高度增加，pixels 并没有增加, 调用下面的方法校准
      Scrollable.of(n.context!).position.correctBy(delta);
    }
  }

  @override
  void onScrollUpdate(ScrollUpdateNotification n) {
    final scrollDelta = n.scrollDelta;
    if (scrollDelta != null) {
      final mes = n.metrics;
      if (n.dragDetails == null) {
        // return;
      }
      if ((value > 0.0) && (scrollDelta < 0 || mes.extentAfter == 0.0)) {
        final newValue = (value + scrollDelta).clamp(0.0, maxExtent);
        _setValue(newValue);
      }
    }
  }

  @override
  void onOverScrollIndicator(OverscrollIndicatorNotification n) {
    if (!n.leading) {
      n.disallowIndicator();
    }
  }
}

abstract class _RefreshBase extends ChangeNotifier {
  _RefreshBase();
  RunningDelegate? runningDelegate;
  void _setDelegate(RunningDelegate? delegate) {
    runningDelegate?._refresh = null;
    runningDelegate = delegate;
    runningDelegate?._refresh = this;
  }

  double get maxExtent => runningDelegate?.maxExtent ?? 0.0;

  double get fac => maxExtent == 0.0 ? 0.0 : value / maxExtent;
  double _value = 0.0;

  double get value => _value;
  bool canLoading = false;

  bool getCanLoading(ScrollStartNotification n);

  void reset(ScrollStartNotification n) {
    canLoading = getCanLoading(n) ||
        runningDelegate?.triggerMode == RefreshIndicatorTriggerMode.anywhere;
    if (!canLoading) return;
    _setMode(RefreshLoadingMode.dragStart);
  }

  void _setValue(double v, [bool animated = false]) {
    final _v = v.clamp(0.0, maxExtent);
    if (_v == _value) return;

    _value = _v;
    if (_value == 0.0) {
      _setMode(RefreshLoadingMode.idle);
    } else if (!animated) {
      if ((_value - maxExtent).abs() < 0.1) {
        _setMode(RefreshLoadingMode.dragEnd);
      } else {
        _setMode(RefreshLoadingMode.draging);
      }
    }

    notifyListeners();
  }

  final ValueNotifier<RefreshLoadingMode> _mode =
      ValueNotifier(RefreshLoadingMode.idle);
  RefreshLoadingMode get mode => _mode.value;

  addModeListener(VoidCallback listener) {
    _mode.addListener(listener);
  }

  removeModeListener(VoidCallback listener) {
    _mode.removeListener(listener);
  }

  void _setMode(RefreshLoadingMode m) {
    _mode.value = m;
  }

  bool get _active => runningDelegate != null;

  bool onNotifition(Notification notification) {
    if (!_active) return false;
    var short = false;
    if (notification is ViewportNotificationMixin) {
      if (notification.depth > 0) return false;
    }
    if (notification is ScrollMetricsNotification) {
      short = notification.metrics.maxScrollExtent <=
          notification.metrics.viewportDimension;
    }
    if (notification is OverscrollIndicatorNotification) {
      onOverScrollIndicator(notification);
    } else if (notification is ScrollStartNotification) {
      reset(notification);
    } else if (notification is ScrollUpdateNotification) {
      goScrollUpdate(notification);
    } else if (notification is OverscrollNotification) {
      goOverScroll(notification);
    } else if (notification is ScrollEndNotification) {
      goScrollEnd(notification);
    }
    return canLoading && value > 0 && short;
  }

  void goScrollUpdate(ScrollUpdateNotification n) {
    if (!canLoading) return;
    onScrollUpdate(n);
  }

  void onScrollUpdate(ScrollUpdateNotification n);

  void goOverScroll(OverscrollNotification n) {
    if (!canLoading) return;
    onOverScroll(n);
  }

  void onOverScroll(OverscrollNotification n);

  void onOverScrollIndicator(OverscrollIndicatorNotification n);
  void goScrollEnd(ScrollEndNotification n) {
    if (!canLoading) return;

    if ((value - maxExtent).abs() < 0.5) {
      _setValue(maxExtent);
      _setMode(RefreshLoadingMode.running);
    } else if (mode != RefreshLoadingMode.animatedIgnore) {
      if (value != 0) {
        _setMode(RefreshLoadingMode.ignore);
      }
    }
  }
}

class _RefreshLoadingWidget extends StatefulWidget {
  const _RefreshLoadingWidget({Key? key, required this.refreshBase})
      : super(key: key);

  final _RefreshBase refreshBase;
  @override
  _RefreshLoadingWidgetState createState() => _RefreshLoadingWidgetState();
}

class _RefreshLoadingWidgetState extends State<_RefreshLoadingWidget>
    with TickerProviderStateMixin {
  late _RefreshBase refreshBase;
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    refreshBase = widget.refreshBase;
    animationController = AnimationController.unbounded(
        vsync: this, duration: const Duration(milliseconds: 300));
    animationController.addListener(_tick);
    refreshBase.addModeListener(_updateMode);
    refreshBase.runningDelegate!._context = context;
  }

  void _tick() {
    final controller = refreshBase;
    final value = animationController.value;
    controller._setValue(value, true);
  }

  Timer? waitAnimated;
  Future<void>? _runningWork;

  /// onRunning 如果成功，不再调用
  bool? _success;
  bool get success => _success ?? false;
  bool _isRunOnce = false;
  RefreshLoadingMode _lastMode = RefreshLoadingMode.idle;
  void _updateMode() {
    final controller = refreshBase;
    waitAnimated?.cancel();

    void _startAnimated() {
      animationController.value = controller.value;
      animationController.animateTo(0,
          duration: const Duration(milliseconds: 600), curve: Curves.ease);
    }

    final running = controller.runningDelegate;
    final mode = controller.mode;

    if (running == null) return;

    switch (mode) {
      case RefreshLoadingMode.dragStart:
        if (_lastMode == RefreshLoadingMode.idle) {
          _lastMode = mode;
          return;
        }
        break;
      case RefreshLoadingMode.draging:
        if (_isRunOnce) break;
        _isRunOnce = true;
        running.onDragStart?.call();
        break;
      case RefreshLoadingMode.dragEnd:
        running.onDragEnd?.call();
        break;
      // 刷新事件
      case RefreshLoadingMode.running:
        final onRunning = running.onRunning;
        if (success || onRunning == null) {
          controller._setMode(RefreshLoadingMode.done);
          return;
        }
        _success = false;
        Future<void>? local;

        local = _runningWork = _runningWork.waitThen(() async {
          if (!mounted) return;
          bool refreshCondition() {
            return controller == refreshBase &&
                refreshBase.runningDelegate == controller.runningDelegate &&
                refreshBase.runningDelegate?.onRunning == onRunning;
          }

          var failed = false;
          if (refreshCondition()) {
            try {
              final stop = Stopwatch()..start();
              await onRunning();
              final useTime = stop.elapsedMilliseconds;
              final max = running.maxDurationOnRunning.inMilliseconds;
              if (useTime < max) {
                await Future.delayed(Duration(milliseconds: max - useTime));
              }
            } catch (e) {
              failed = true;
            }
          }
          if (_success != null) {
            _success = _success! | !failed;
          }
          if (refreshCondition() &&
              controller.mode == RefreshLoadingMode.running) {
            if (success) {
              controller._setMode(RefreshLoadingMode.done);
            } else {
              controller._setMode(RefreshLoadingMode.failed);
            }
          }
          if (local == _runningWork) {
            _runningWork = null;
          }
        });

        break;

      // 动画事件
      case RefreshLoadingMode.ignore:
        running.onDragIgnore?.call();

        _startAnimated();
        controller._setMode(RefreshLoadingMode.animatedIgnore);
        return;
      case RefreshLoadingMode.done:
        running.onDone?.call();

        waitAnimated = Timer(running.waitingOnDone, () {
          if (refreshBase == controller && mounted) {
            _startAnimated();
            refreshBase._setMode(RefreshLoadingMode.animatedDone);
          }
        });
        break;

      case RefreshLoadingMode.idle:
        _success = null;
        _runningWork = null;
        _isRunOnce = false;
        break;
      default:
    }
    switch (mode) {
      case RefreshLoadingMode.idle:
      // 用户行为
      case RefreshLoadingMode.dragStart:
      case RefreshLoadingMode.draging:
      case RefreshLoadingMode.dragEnd:
        if (animationController.isAnimating) {
          animationController.stop(canceled: true);
        }
        break;
      default:
    }
    if (_secheduled) return;
    final scheduler = SchedulerBinding.instance;
    switch (scheduler.schedulerPhase) {
      case SchedulerPhase.persistentCallbacks:
        // 添加到帧后回调
        scheduler.addPostFrameCallback((timeStamp) {
          _secheduled = false;
          _update();
        });
        _secheduled = true;
        break;
      default:
        _update();
    }

    _lastMode = mode;
  }

  void _update() {
    if (mounted) setState(() {});
  }

  bool _secheduled = false;

  @override
  void didUpdateWidget(covariant _RefreshLoadingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (refreshBase != widget.refreshBase) {
      refreshBase.removeListener(_updateMode);
      refreshBase = widget.refreshBase;
      refreshBase.addListener(_updateMode);
    }
    refreshBase.runningDelegate!._context = context;
  }

  @override
  void dispose() {
    animationController.dispose();
    refreshBase.removeModeListener(_updateMode);
    refreshBase.runningDelegate!._context = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = Scrollable.of(context).position;
    return AnimatedBuilder(
        animation: refreshBase,
        builder: (context, _) {
          assert(refreshBase.runningDelegate != null);
          final builder = refreshBase.runningDelegate!.builder;
          final isVertical = position.axis == Axis.vertical;

          position.axisDirection;
          return SizedBox(
            height: isVertical ? refreshBase.value : 0.0,
            width: isVertical ? 0.0 : refreshBase.value,
            child: builder(
              context,
              refreshBase.maxExtent - refreshBase._value,
              refreshBase.maxExtent,
              refreshBase.mode.outerMode,
              _runningWork != null,
              success,
            ),
          );
        });
  }
}

extension on Future? {
  Future<T> waitThen<T>(Future<T> Function() action) {
    final that = this;
    if (that is Future) {
      return that.then((_) => action(), onError: (_) => action());
    }
    return action();
  }
}

/// 滚动位移约束在[minScrollExtent]-[maxScrollExtent]之间
///
/// 不会出现 outOfRange 的情况
class ClampBouncingScrollPhysics extends ScrollPhysics {
  const ClampBouncingScrollPhysics(this._refresh, this._loading,
      {ScrollPhysics? parent})
      : super(parent: parent);
  final _RefreshBase _refresh;
  final _RefreshBase _loading;
  @override
  ClampBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ClampBouncingScrollPhysics(_refresh, _loading, parent: parent);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final simulation = super.createBallisticSimulation(position, velocity);
    if (simulation == null) return null;

    double max = position.maxScrollExtent;
    double min = position.minScrollExtent;

    // 处于边界时不需要有动画，否则会有停顿的情况发生
    if (position.outOfRange || position.atEdge) {
      if (velocity == 0) return null;
    }
    if (position.pixels <= position.minScrollExtent) {
      if (_refresh.value != 0) {
        if (velocity < 0) {
          return null;
        }
      }
      min = position.minScrollExtent - _refresh.value;
    } else if (position.pixels >= position.maxScrollExtent) {
      if (_loading.value != 0) {
        if (velocity > 0) {
          return null;
        }
      }
      max = position.maxScrollExtent + _refresh.value;
    }

    return ClampedSimulation(simulation, xMax: max, xMin: min);
  }
}
