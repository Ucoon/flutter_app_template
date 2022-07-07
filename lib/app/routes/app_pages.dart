import 'package:get/get.dart';

import '../middleware/router_login.dart';
import '../modules/login/index.dart';
import '../modules/tab/index.dart';
import '../modules/webview/index.dart';
import '../modules/welcome/index.dart';
part 'app_routes.dart';

class AppPages {
  static const initial = Routes.initial;

  static final List<GetPage> routes = [
    GetPage(
      name: _Paths.initial,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
      middlewares: [
        RouteLoginMiddleware(priority: 0),
      ],
    ),
    GetPage(
      name: _Paths.tab,
      page: () => const TabHomePage(),
      binding: TabHomeBinding(),
    ),
    GetPage(
      name: _Paths.customWebView,
      page: () => CustomWebPage(),
      binding: CustomWebViewBinding(),
    ),
  ];
}
