import 'dart:async';

import 'package:flutter/material.dart';

typedef AutoScrollBuilder = Widget Function(
    BuildContext contxt, int index, int realIndex);

class AutoScrollOptions {
  final int itemCount;
  final int initIndex;
  final Duration duration;
  final Duration animationInterval;
  final double itemExtent;
  final bool autoPlay;
  final Curve curve;
  final bool ignoreDrag;
  final Axis direction;
  final int shrinkCount;
  final bool animationReverse;
  final bool scrollReverse;

  static const _indexPadleft = 1000000000;

  AutoScrollOptions({
    required this.itemCount,
    this.initIndex = 0,
    this.autoPlay = true,
    this.animationInterval = const Duration(seconds: 4),
    this.duration = const Duration(milliseconds: 340),
    this.itemExtent = 50,
    this.ignoreDrag = true,
    this.direction = Axis.vertical,
    this.animationReverse = false,
    this.scrollReverse = false,
    this.curve = Curves.easeInOut,
    int shrinkCount = 0,
  }) : shrinkCount = shrinkCount + itemCount * 2;

  ScrollController? _controller;

  int get currentIndex {
    if (_controller == null) return 0;
    return getIndex(getRealIndex(_controller!.offset));
  }

  double get initOffset {
    return (_indexPadleft + initIndex) * itemExtent;
  }

  // 滚动列表的 index
  int getIndex(int index) {
    return (index - _indexPadleft) % itemCount;
  }

  // 从 ScrollPositon.pixels 中计算出真实的 index
  int getRealIndex(double offset) {
    return offset ~/ itemExtent;
  }

  bool shouldUpdateTimer(AutoScrollOptions other) {
    return autoPlay != other.autoPlay ||
        duration != other.duration ||
        animationInterval != other.animationInterval;
  }

  // 即将动画到的位置
  double getNextOffset(double offset) {
    var nextPage = offset / itemExtent;

    if (animationReverse) {
      nextPage -= 0.51;
    } else {
      nextPage += 0.51;
    }
    return nextPage.round() * itemExtent;
  }

  // 自动收缩
  void autoShrink(double offset, void Function(double offset) jump) {
    final realIndex = getRealIndex(offset);

    if ((realIndex - _indexPadleft).abs() > shrinkCount) {
      final index = getIndex(realIndex);
      final newRealIndex = index + _indexPadleft;
      assert(() {
        // ignore: avoid_print
        print(
            'index: $index | realIndex: $realIndex | newRealIndex: $newRealIndex');
        return true;
      }());
      jump(newRealIndex * itemExtent);
    }
  }

  // 判断是否可滚动
  bool isShort(double extent) {
    return extent / itemExtent >= itemCount;
  }
}

class AutoSrcollListView extends StatefulWidget {
  const AutoSrcollListView({
    Key? key,
    required this.itemBuilder,
    required this.autoScrollOptions,
  }) : super(key: key);
  final AutoScrollBuilder itemBuilder;
  final AutoScrollOptions autoScrollOptions;

  @override
  State<AutoSrcollListView> createState() => _AutoSrcollListViewState();
}

class _AutoSrcollListViewState extends State<AutoSrcollListView> {
  late ScrollController scrollController;
  late AutoScrollOptions options;
  @override
  void initState() {
    super.initState();
    options = widget.autoScrollOptions;
    scrollController =
        ScrollController(initialScrollOffset: options.initOffset);
    options._controller = scrollController;
    createTimer();
  }

  bool animateDone = true;
  void startAnimated() {
    if (!mounted || // dispose
            !animateDone || // 动画未完成
            !_canAnimated || // 不需要动画
            _userGes || // 用户正在使用手势
            !scrollController.hasClients // 没有滚动列表
        ) return;

    animateDone = false;
    scrollController
        .animateTo(options.getNextOffset(scrollController.offset),
            duration: options.duration, curve: options.curve)
        .whenComplete(() {
      animateDone = true;
      if (!_userGes && scrollController.hasClients) {
        options.autoShrink(
          scrollController.position.pixels,
          scrollController.jumpTo,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant AutoSrcollListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldPotions = options;
    options = widget.autoScrollOptions;
    options._controller = scrollController;
    if (oldPotions.shouldUpdateTimer(options)) {
      createTimer();
    }
  }

  Timer? timer;

  void createTimer() {
    resetTimer();
    if (options.autoPlay) {
      timer = Timer.periodic(options.animationInterval + options.duration, (t) {
        if (!mounted) {
          timer?.cancel();
          timer = null;
          return;
        }
        startAnimated();
      });
    }
  }

  void resetTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    resetTimer();
    super.dispose();
  }

  // 用户的手势状态
  bool _userGes = false;
  bool onNotification(Notification notification) {
    if (notification is ScrollStartNotification) {
      _userGes = true;
    } else if (notification is ScrollEndNotification) {
      _userGes = false;
    }
    return false;
  }

  bool _canAnimated = true;

  @override
  Widget build(BuildContext context) {
    if (options.itemCount == 0) {
      return const SizedBox();
    }
    final physics =
        options.ignoreDrag ? const NeverScrollableScrollPhysics() : null;
    return LayoutBuilder(builder: (context, constaints) {
      final extent = options.direction == Axis.vertical
          ? constaints.maxHeight
          : constaints.maxWidth;
      _canAnimated = !options.isShort(extent);

      if (!_canAnimated) {
        return ListView.builder(
          cacheExtent: 0,
          shrinkWrap: true,
          reverse: options.scrollReverse,
          physics: physics,
          scrollDirection: options.direction,
          padding: EdgeInsets.zero,
          itemCount: options.itemCount,
          itemExtent: options.itemExtent,
          itemBuilder: _noAnimationBuilder,
        );
      }
      return NotificationListener(
        onNotification: onNotification,
        child: ListView.builder(
          cacheExtent: 0,
          reverse: options.scrollReverse,
          scrollDirection: options.direction,
          physics: physics,
          controller: scrollController,
          padding: EdgeInsets.zero,
          itemBuilder: _builder,
          itemExtent: options.itemExtent,
        ),
      );
    });
  }

  Widget _noAnimationBuilder(context, index) {
    return widget.itemBuilder(context, index, index);
  }

  Widget _builder(BuildContext context, int index) {
    return widget.itemBuilder(context, options.getIndex(index), index);
  }
}
