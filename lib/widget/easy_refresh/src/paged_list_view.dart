import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/app/base/model/base_page_list_resp.dart';
import '/widget/widget.dart';

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
    String _refreshTitle = '';
    if (enableInfiniteRefresh) {
      _refreshTitle = 'refreshing'.tr;
    } else {
      switch (refreshState) {
        case RefreshMode.refresh:
          _refreshTitle = 'refreshing'.tr;
          break;
        case RefreshMode.refreshed:
          _refreshTitle = 'refresh_done'.tr;
          break;
        case RefreshMode.done:
          _refreshTitle = 'refresh_success'.tr;
          break;
        case RefreshMode.inactive:
          _refreshTitle = 'refresh_cancel'.tr;
          break;
        case RefreshMode.armed:
          _refreshTitle = 'refresh_release'.tr;
          break;
        case RefreshMode.drag:
          _refreshTitle = 'refresh_drag'.tr;
          break;
        default:
      }
    }
    late final Widget _child = Container(
      margin: EdgeInsets.only(top: 10.5.h),
      child: Text(
        _refreshTitle,
        style: TextStyle(
          color: const Color(0xFFB3B3B3),
          fontSize: 12.sp,
        ),
      ),
    );
    return RepaintBoundary(
      child: Align(
        alignment: const Alignment(0, -0.5),
        child: ClipRect(
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            children: <Widget>[
              SizedBox(
                width: ScreenUtil().screenWidth,
                child: const LoadingWidget(stop: false),
              ),
              _child,
            ],
          ),
        ),
      ),
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
    String _loadingTitle = '';
    if (enableInfiniteLoad) {
      _loadingTitle = 'loading'.tr;
    } else {
      switch (loadState) {
        case LoadMode.loaded:
        case LoadMode.done:
          _loadingTitle = 'load_done'.tr;
          break;
        case LoadMode.inactive:
        case LoadMode.load:
        case LoadMode.armed:
        case LoadMode.drag:
          _loadingTitle = 'loading'.tr;
          break;
        default:
      }
    }
    late final Widget _child = Text(
      _loadingTitle,
      style: TextStyle(
        color: const Color(0xFFB3B3B3),
        fontSize: 12.sp,
      ),
    );
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
              _child,
            ],
          ),
        ),
      ),
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
    this.emptyIconWidth = 142,
    this.emptyIconHeight = 110,
    this.scrollDirection = Axis.vertical,
    this.itemCount,
    this.onLoad,
    this.onRefresh,
    this.padding,
  }) : super(key: key);

  final String emptyIcon;
  final String emptyText;
  final String emptyHint;
  final double emptyIconWidth;
  final double emptyIconHeight;
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
              iconWidth: emptyIconWidth,
              iconHeight: emptyIconHeight,
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
