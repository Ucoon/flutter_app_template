import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/common/utils/utils.dart';
import '../../classify/index.dart';
import '../../global/index.dart';
import '../../home/index.dart';
import '../../personal/index.dart';
import '../index.dart';

class TabHomePage extends StatefulWidget {
  const TabHomePage({Key? key}) : super(key: key);
  @override
  State<TabHomePage> createState() => TabHomePageState();
}

class TabHomePageState extends State<TabHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TabHomeController get controller => Get.find();

  /// 内容页
  Widget _buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
        HomePage(),
        GlobalPurchasingPage(),
        ClassifyPage(),
        PersonalPage(),
      ],
      controller: controller.pageController,
      onPageChanged: controller.handlePageChanged,
    );
  }

  /// 底部导航
  Widget _buildBottomNavigationBar() {
    List<BottomNavigationBarItem> _bottomItems = _createBottomItems();
    return Obx(
      () => BottomNavigationBar(
        items: _bottomItems,
        currentIndex: controller.state.page,
        backgroundColor: const Color(0xFFFFFEFF),
        unselectedItemColor: const Color(0xFF828489),
        selectedItemColor: const Color(0xFFDB593A),
        type: BottomNavigationBarType.fixed,
        onTap: controller.handleNavBarTap,
        selectedFontSize: 10.sp,
        unselectedFontSize: 10.sp,
        iconSize: 32.w,
      ),
    );
  }

  List<BottomNavigationBarItem> _createBottomItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.home_outlined,
          color: Colors.grey,
        ),
        activeIcon: const Icon(
          Icons.home_outlined,
          color: Colors.red,
        ),
        label: 'tab_home'.tr,
      ),
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.settings_outlined,
          color: Colors.grey,
        ),
        activeIcon: const Icon(
          Icons.settings_outlined,
          color: Colors.red,
        ),
        label: 'tab_global_purchasing'.tr,
      ),
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.add_alarm,
          color: Colors.grey,
        ),
        activeIcon: const Icon(
          Icons.add_alarm,
          color: Colors.red,
        ),
        label: 'tab_cash'.tr,
      ),
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.person_outline,
          color: Colors.grey,
        ),
        activeIcon: const Icon(
          Icons.person_outline,
          color: Colors.red,
        ),
        label: 'tab_personal'.tr,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: AppKit.exitApplication,
      child: Scaffold(
        body: _buildPageView(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
}
