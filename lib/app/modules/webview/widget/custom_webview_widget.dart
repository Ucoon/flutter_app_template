import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../index.dart';

typedef WebViewCallback = void Function();

class CustomWebWidget<T extends JsBridgeController> extends GetWidget<T> {
  final String url;
  final WebViewCallback? webViewControllerCallback;
  final bool showProgress;

  const CustomWebWidget(
    this.url, {
    Key? key,
    this.showProgress = true,
    this.webViewControllerCallback,
  }) : super(key: key);

  WebView _buildWebView(BuildContext context) {
    WebView _webView = WebView(
      javascriptChannels: controller.jsBridge.jsChannels,
      javascriptMode: JavascriptMode.unrestricted,
      debuggingEnabled: kDebugMode,
      onProgress: (progress) {
        if (showProgress) {
          controller.progress = progress;
        }
      },
      onWebViewCreated: (webController) {
        debugPrint('CustomWebWidget._buildWebView onWebViewCreated');
        controller.jsBridge.controller = webController;
        controller.initRegister();
        if (webViewControllerCallback != null) {
          webViewControllerCallback!();
        }
      },
      navigationDelegate: (NavigationRequest navigation) {
        debugPrint('navigationDelegate ${navigation.url}');
        if (navigation.url.contains('__bridge_loaded__')) {
          controller.jsBridge.injectJsBridge();
          return NavigationDecision.prevent;
        } else if (_isPreventNavigation(navigation.url)) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onWebResourceError: (WebResourceError error) {
        debugPrint('CustomWebWidget._buildWebView onWebResourceError $error');
      },
      onPageFinished: (String url) {
        debugPrint('CustomWebWidget._buildWebView onPageFinished');
        controller.jsBridge.injectJsBridge();
      },
      initialUrl: url,
    );
    return _webView;
  }

  _progressBar(BuildContext context) {
    return Obx(() {
      double progress = controller.progress / 100;
      debugPrint('_progressBar $progress');
      return LinearProgressIndicator(
        backgroundColor: Colors.white70.withOpacity(0),
        value: progress == 1.0 ? 0 : progress,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return showProgress
        ? Stack(
            children: [
              _buildWebView(context),
              Positioned(
                  left: 0, top: 0, right: 0, child: _progressBar(context))
            ],
          )
        : _buildWebView(context);
  }

  ///是否包含打开第三方app scheme链接
  bool _isPreventNavigation(String url) {
    return url.contains('tbopen://m.taobao.com/') || //淘宝
        url.contains('openapp.jdmobile:') || //京东
        url.contains('vmallPullUpApp?launchExtra') || //华为
        url.contains('yanxuan://homepage') ||
        url.contains('mishop://m.mi.com/p'); //严选
  }
}
