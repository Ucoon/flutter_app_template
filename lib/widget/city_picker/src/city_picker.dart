library cascade_picker;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 级联选择器
/// 使用示例:
/// ```dart
/// CascadePicker的page是ListView，没有约束的情况下它的高度是无限的，
/// 因此需要约束高度。
///
/// final _cascadeController = CascadeController();
///
/// initialPageData: 第一页的数据
/// nextPageData: 下一页的数据，点击当前页的选择项后调用该方法加载下一页
///   - pageCallback: 用于传递下一页的数据给CascadePicker
///   - currentPage: 当前是第几页
///   - selectIndex: 当前选中第几项
/// controller: 控制器，用于获取已选择的数据
/// maxPageNum: 最大页数
/// selectedIcon: 已选中选项前面的图标，flutter package不能放本地资源文件，因此需要从外部传入，图标在images文件夹下面
///
/// Expand(
///   child: CascadePicker(
///     initialPageData: ['a', 'b', 'c', 'd'],
///     nextPageData: (pageCallback, currentPage, selectIndex) async {
///       pageCallback(['one', 'two', 'three'])
///     },
///     controller: _cascadeController,
///     maxPageNum: 4,
///     selectedIcon: Image.asset("images/ic_select_mark.png", width: 10, height: 10, color: Colors.redAccent,),
/// )
///
/// InkBox(
///   child: Container(...)
///   onTap: () {
///     /// 判断是否完成选择
///     if (_cascadeController.isCompleted()) {
///       List<String> selectedTitles = _cascadeController.selectedTitles;
///       List<int> selectedIndexes = _cascadeController.selectedIndexes;
///     }
///   }
/// )
/// ```

/// pageData: 下一页的数据
/// currentPage: 当前是第几页,
/// selectIndex: 当前页选中第几项
typedef NextPageCallback = void Function(
    Function(String tabName, List<String>?) pageData,
    int currentPage,
    int selectIndex);

class CityPicker extends StatefulWidget {
  final List<String> initialPageData;
  final NextPageCallback nextPageData;
  final int maxPageNum;
  final CascadeController controller;
  final Color tabColor;
  final double tabHeight;
  final TextStyle tabTitleStyle;
  final double itemHeight;
  final TextStyle itemTitleStyle;
  final Color itemColor;
  final Widget? selectedIcon;
  final Function? onCompleteCallback;

  const CityPicker({
    Key? key,
    required this.initialPageData,
    required this.nextPageData,
    this.maxPageNum = 3,
    required this.controller,
    this.tabHeight = 40,
    this.tabColor = Colors.white,
    this.tabTitleStyle = const TextStyle(
      color: Color(0xFF828489),
      fontSize: 14,
    ),
    this.itemHeight = 40,
    this.itemColor = Colors.white,
    this.itemTitleStyle = const TextStyle(
      color: Color(0xFF3C424D),
      fontSize: 14,
    ),
    this.selectedIcon,
    this.onCompleteCallback,
  }) : super(key: key);

  @override
  _CityPickerState createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker>
    with SingleTickerProviderStateMixin {
  static String get _newTabName => "choose_location".tr;

  late CascadeController _cascadeController;

  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;
  Animation? _sliderAnimation;
  final _sliderFixMargin = ValueNotifier(0.0);
  final double _sliderWidth = 20;

  final PageController _pageController = PageController(initialPage: 0);

  final GlobalKey _sliderKey = GlobalKey();
  final List<GlobalKey> _tabKeys = [];

  /// 选择器数据集合
  final List<List<String>> _pagesData = [];

  /// 已选择的title集合
  final List<String> _selectedTabs = [_newTabName];

  /// 已选择的item index集合
  final List<int> _selectedIndexes = [-1];

  /// "请选择"tab宽度，添加新的tab时用到
  double _animTabWidth = 0;

  /// tab添加事件记录，用于隐藏"请选择"tab初始化状态
  bool _isAddTabEvent = false;

  /// tab移动未开始，渲染'请选择'tab时隐藏文本，这时的tab在终点位置
  bool _isAnimateTextHide = false;

  /// 防止_moveSlider重复调用
  bool _isClickAndMoveTab = false;

  /// 当前选择的页面，移动滑块前赋值
  int _currentSelectPage = 0;

  _addTab(int page, int atIndex, String currentPageItem) {
    _loadNextPageData(page, atIndex, currentPageItem);
  }

  _loadNextPageData(int page, int atIndex, String currentPageItem,
      {bool isUpdatePage = false}) {
    widget.nextPageData((tabName, data) {
      final nextPageDataIsEmpty = data == null || data.isEmpty;
      if (!nextPageDataIsEmpty) {
        /// 下一页有数据，更新本页数据或添加新的页面
        setState(() {
          ///如果已经有tabName，则执行更新操作
          if (isUpdatePage || _selectedTabs.contains(tabName)) {
            /// 更新下一页
            _pagesData[page] = data;
            _selectedTabs[page] = tabName;
            _selectedIndexes[page] = -1;

            /// 清空下下页以后的所有页面和tab数据
            _pagesData.removeRange(page + 1, _pagesData.length);
            _selectedIndexes.removeRange(page + 1, _selectedIndexes.length);
            _selectedTabs.removeRange(page + 1, _selectedTabs.length);
          } else {
            /// 添加新的页面
            _isAnimateTextHide = true;
            _isAddTabEvent = true;
            _pagesData.add(data);
            _selectedTabs.add(tabName);
            _selectedIndexes.add(-1);
          }
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _moveSlider(page, isAdd: true);
          });
        });
      } else {
        /// 如果下一页数据为空，那么更新本页数据
        final currentPage = page - 1;
        setState(() {
          _selectedTabs[currentPage] = currentPageItem;
          _selectedIndexes[currentPage] = atIndex;

          /// 下一页数据为空，清空下一页以后的所有页面和tab数据
          _pagesData.removeRange(page, _pagesData.length);
          _selectedIndexes.removeRange(page, _selectedIndexes.length);
          _selectedTabs.removeRange(page, _selectedTabs.length);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            // 调整滑块位置
            _moveSlider(currentPage);
          });
        });
      }
    }, page, atIndex);
  }

  Future<void> _moveSlider(int page,
      {bool movePage = true, bool isAdd = false}) async {
    if (movePage && _currentSelectPage != page) {
      /// 上一次选择的页面和本次选择的页面不同时，移动tab标签，
      /// 移动时先把_isClickAndMoveTab设为true，防止滑动PageView
      /// 时_moveSlider重复调用。
      _isClickAndMoveTab = true;
    }
    _isAddTabEvent = isAdd;
    _currentSelectPage = page;

    if (_controller.isAnimating) {
      _controller.stop();
    }
    RenderBox slider =
        _sliderKey.currentContext?.findRenderObject() as RenderBox;
    Offset sliderPosition = slider.localToGlobal(Offset.zero);
    RenderBox currentTabBox =
        _tabKeys[page].currentContext?.findRenderObject() as RenderBox;
    Offset currentTabPosition = currentTabBox.localToGlobal(Offset.zero);

    _animTabWidth = currentTabBox.size.width;

    final begin = sliderPosition.dx - _sliderFixMargin.value;
    final end = currentTabPosition.dx +
        (currentTabBox.size.width - _sliderWidth) / 2 -
        _sliderFixMargin.value;
    _sliderAnimation =
        Tween<double>(begin: begin, end: end).animate(_curvedAnimation);
    _controller.value = 0;
    _controller.forward();
    if (movePage) {
      return _pageController.animateToPage(page,
          curve: Curves.linear, duration: const Duration(milliseconds: 500));
    }
  }

  /// 注意：tab渲染完成才开始动画，即调用moveSlider，这个方法会在动画执行期间多次调用
  Widget _animateTab({required Widget tab}) {
    return Transform.translate(
      offset: Offset(
          Tween<double>(begin: _isAddTabEvent ? -_animTabWidth : 0, end: 0)
              .evaluate(_curvedAnimation),
          0),
      child: Opacity(

          /// 动画未开始前隐藏文本
          opacity: _isAnimateTextHide ? 0 : 1,
          child: tab),
    );
  }

  List<Widget> _tabWidgets() {
    List<Widget> widgets = [];
    _tabKeys.clear();
    for (int i = 0; i < _pagesData.length; i++) {
      GlobalKey key = GlobalKey();
      _tabKeys.add(key);
      final tab = GestureDetector(
        child: Container(
          key: key,
          height: widget.tabHeight,
          color: widget.tabColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.of(context).size.width / _pagesData.length - 10),
            child: Text(
              _selectedTabs[i],
              style: _currentSelectPage == i
                  ? widget.tabTitleStyle
                      .copyWith(color: const Color(0xFF3C424D))
                  : widget.tabTitleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        onTap: () {
          _moveSlider(i);
        },
      );
      if (i == _pagesData.length - 1 && _selectedTabs[i] == _newTabName) {
        widgets.add(_animateTab(tab: tab));
        _isAnimateTextHide = false;
      } else {
        widgets.add(tab);
      }
    }
    return widgets;
  }

  /// 选择项
  Widget _pageItemWidget(int index, int page, String item) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: widget.itemHeight,
        color: widget.itemColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(item,
                style: item == _selectedTabs[page]
                    ? widget.itemTitleStyle
                        .copyWith(color: const Color(0xFFDC593B))
                    : widget.itemTitleStyle),
            item == _selectedTabs[page]
                ? widget.selectedIcon ??
                    const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Color(0xFFFD7400),
                    )
                : const SizedBox(),
          ],
        ),
      ),
      onTap: () {
        if (page == widget.maxPageNum - 1) {
          /// 当前页是最后一页
          setState(() {
            _selectedTabs[page] = item;
            _selectedIndexes[page] = index;

            /// 调整滑块位置
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _moveSlider(page);
              widget.onCompleteCallback?.call();
            });
          });
        } else if (_tabKeys.length >= widget.maxPageNum ||
            page < _tabKeys.length - 1) {
          if (index == _selectedIndexes[page]) {
            /// 选择相同的item
            _moveSlider(page + 1);
          } else {
            /// 选择不同的item，更新tab renderBox
            setState(() {
              _selectedTabs[page] = item;
              _selectedIndexes[page] = index;
            });
            _loadNextPageData(page + 1, index, item, isUpdatePage: true);
          }
        } else {
          /// 添加新tab页面
          /// page == _tabKeys.length - 1 && _tabKeys.length == widget.maxPageNum
          _selectedTabs[page] = item;
          _selectedIndexes[page] = index;
          _addTab(page + 1, index, item);
        }
      },
    );
  }

  Widget _pageWidget(int page) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _pagesData[page].length,
      itemBuilder: (context, index) => _pageItemWidget(
        index,
        page,
        _pagesData[page][index],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cascadeController = widget.controller;
    _cascadeController._setState(this);
    _pagesData.add(widget.initialPageData);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.ease)
      ..addStatusListener((state) {});

    _sliderAnimation =
        Tween<double>(begin: 0, end: 10).animate(_curvedAnimation);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox tabBox =
          _tabKeys.first.currentContext?.findRenderObject() as RenderBox;
      _sliderFixMargin.value = (tabBox.size.width - _sliderWidth) / 2;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedBuilder(
          animation: _sliderAnimation!,
          builder: (context, child) => Stack(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.bottomLeft,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: _tabWidgets(),
                ),
              ),
              ValueListenableBuilder<double>(
                valueListenable: _sliderFixMargin,
                builder: (_, margin, __) => Positioned(
                  left: margin + _sliderAnimation!.value,
                  child: Container(
                    key: _sliderKey,
                    width: _sliderWidth,
                    height: 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC593B),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 1,
          color: const Color(0xFFE8E8E8),
          margin: const EdgeInsets.symmetric(vertical: 4),
        ),
        Expanded(
          child: PageView.builder(
            itemCount: _pagesData.length,
            controller: _pageController,
            itemBuilder: (context, index) => _pageWidget(index),
            onPageChanged: (position) {
              if (!_isClickAndMoveTab) {
                _moveSlider(position, movePage: false);
              }
              if (_currentSelectPage == position) {
                _isClickAndMoveTab = false;
              }
            },
          ),
        )
      ],
    );
  }
}

class CascadeController {
  late final _CityPickerState _state;

  _setState(_CityPickerState state) {
    _state = state;
  }

  List<String> get selectedTitles => _state._selectedTabs;

  List<int> get selectedIndexes => _state._selectedIndexes;

  bool isCompleted() =>
      !_state._selectedTabs.contains(_CityPickerState._newTabName);
}
