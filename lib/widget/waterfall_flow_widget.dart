import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'widget.dart';
import '../app/base/model/base_page_list_resp.dart';

///瀑布流布局列表(包含分页)
class WaterFallFlowWidget<T extends BasePageRespEntry> extends StatefulWidget {
  final ScrollController? controller;
  final List<T> items;
  final int? itemCount;
  final Function itemBuilder;
  final String emptyIcon;
  final String emptyText;
  final String emptyHint;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final String noMoreText;
  final Function? onRefresh;
  final Function? onLoadMore;

  WaterFallFlowWidget({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.emptyIcon,
    required this.emptyText,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 7.0,
    this.mainAxisSpacing = 7.0,
    this.emptyHint = '',
    String? noMoreText,
    this.controller,
    this.itemCount,
    this.physics,
    this.onRefresh,
    this.onLoadMore,
  })  : noMoreText = noMoreText ?? 'wall_no_more_default'.tr,
        super(key: key);

  @override
  _WaterFallFlowWidgetState createState() => _WaterFallFlowWidgetState();
}

class _WaterFallFlowWidgetState extends State<WaterFallFlowWidget> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (widget.onLoadMore == null) return;
        widget.onLoadMore!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.itemCount ?? widget.items.length) == 0) {
      return Center(
        child: EmptyResultWidget(
          icon: widget.emptyIcon,
          text: widget.emptyText,
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        if (widget.onRefresh == null) return Future.value();
        widget.onRefresh!();
      },
      child: WaterfallFlow.builder(
        padding: widget.padding,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          crossAxisSpacing: widget.crossAxisSpacing,
          mainAxisSpacing: widget.mainAxisSpacing,
        ),
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.itemBuilder(index);
        },
      ),
    );
  }
}
