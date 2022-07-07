import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/base/model/base_page_list_resp.dart';
import '../../element.dart';
import 'empty_result_widget.dart';

typedef OnRefreshCallback = Future<void> Function();

Header refreshHead = CustomHeader(
  float: false,
  headerBuilder: (BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration? completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: buildLoading(),
        ),
      ],
    );
  },
);

Footer loadFooter = CustomFooter(
  footerBuilder: (BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration? completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: buildLoading(),
        ),
      ],
    );
  },
  enableInfiniteLoad: false,
);

///分页加载组件
class PagedListView<T extends BasePageRespEntry> extends StatelessWidget {
  const PagedListView(
    this.items,
    this.itemBuilder, {
    Key? key,
    required this.emptyIcon,
    this.emptyText = '',
    this.emptyHint = '',
    this.emptyIconSize = 208,
    this.scrollDirection = Axis.vertical,
    this.itemCount,
    this.onLoad,
    this.onRefresh,
    this.padding,
  }) : super(key: key);

  final String emptyIcon;
  final String emptyText;
  final String emptyHint;
  final double emptyIconSize;
  final Axis scrollDirection; //列表方向,默认垂直方向
  final Widget Function(T value, int index) itemBuilder;
  final List<T> items;
  final int? itemCount;
  final OnRefreshCallback? onLoad;
  final OnRefreshCallback? onRefresh;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    final listPadding = padding ?? EdgeInsets.symmetric(vertical: 11.h);
    return EasyRefresh.custom(
      shrinkWrap: true,
      header: refreshHead,
      footer: loadFooter,
      emptyWidget: items.isEmpty
          ? EmptyResultWidget(
              icon: emptyIcon,
              text: emptyText,
              hint: emptyHint,
              iconSize: emptyIconSize,
            )
          : null,
      onLoad: onLoad,
      onRefresh: onRefresh,
      slivers: <Widget>[
        SliverPadding(
          padding: listPadding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == items.length) {
                  return const SizedBox(
                    height: 8,
                  );
                }
                final item = items[index];
                return itemBuilder(item, index);
              },
              childCount: (itemCount ?? items.length) + 1,
            ),
          ),
        ),
      ],
    );
  }
}
