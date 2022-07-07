part of 'app_pages.dart';

abstract class Routes {
  static const initial = _Paths.initial;
  static login(String from) => '${_Paths.login}/$from';
  static const tab = _Paths.tab;
  static const customWebView = _Paths.customWebView;
}

abstract class _Paths {
  static const initial = '/';
  static const login = '/login';
  static const tab = '/tab';
  static const customWebView = '/customWebView';
}
