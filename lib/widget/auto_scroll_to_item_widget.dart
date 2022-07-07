import 'dart:async';

import 'package:flutter/material.dart';

class ScrollToItemBaseObject {
  final GlobalKey globalKey = GlobalKey();
}

class AutoScrollToItemWidget extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final List<ScrollToItemBaseObject> list;
  final Duration? duration;
  final double topDistance;

  const AutoScrollToItemWidget(
      {Key? key,
      required this.list,
      this.duration,
      this.topDistance = 0,
      required this.itemBuilder})
      : super(key: key);

  @override
  _ScrollToItemState createState() => _ScrollToItemState();
}

class _ScrollToItemState extends State<AutoScrollToItemWidget> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scrollKey = GlobalKey();
  Timer? _timer;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _startTimer();
  }

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        if (widget.list.isEmpty) {
          return;
        }
        if (currentIndex == widget.list.length - 1) {
          currentIndex = 0;
        } else {
          currentIndex = currentIndex + 2;
          if (currentIndex >= widget.list.length - 1) {
            currentIndex = widget.list.length - 1;
          }
        }
        scrollToIndex(currentIndex);
      } else {
        _timer?.cancel();
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: _scrollKey,
      controller: _scrollController,
      child: ListView.builder(
        itemBuilder: widget.itemBuilder,
        itemCount: widget.list.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AutoScrollToItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  // 滑动到指定下标的item
  void scrollToIndex(int index) {
    if (index > widget.list.length) {
      return;
    }
    ScrollToItemBaseObject item = widget.list[index];
    if (item.globalKey.currentContext != null) {
      RenderBox renderBox =
          item.globalKey.currentContext!.findRenderObject() as RenderBox;
      double dy = renderBox
          .localToGlobal(Offset.zero,
              ancestor: _scrollKey.currentContext!.findRenderObject())
          .dy;
      var offset = dy + _scrollController.offset;
      // double stateTopHei = MediaQueryData.fromWindow(window).padding.top;
      _scrollController.animateTo(offset - widget.topDistance,
          duration: widget.duration ?? const Duration(milliseconds: 500),
          curve: Curves.linear);
    } else {
      debugPrint("Please bind the key to the widget");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _cancelTimer();
  }
}
