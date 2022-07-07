library webview_jsbridge;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef WebViewJSBridgeHandler<T extends Object?> = Future<T?> Function(
    Object? data);

class WebViewJSBridge {
  final Map<int, Completer> _completerMap = <int, Completer>{};
  final Map<String, WebViewJSBridgeHandler> _handlers =
      <String, WebViewJSBridgeHandler>{};

  int _completerIndex = 0;
  WebViewController? controller;
  WebViewJSBridgeHandler? defaultHandler;

  Set<JavascriptChannel> get jsChannels => <JavascriptChannel>{
        JavascriptChannel(
          name: 'YGFlutterJSBridgeChannel',
          onMessageReceived: _onMessageReceived,
        ),
      };

  Future<void> injectJsBridge() async {
    String jsFile = await rootBundle.loadString('assets/bridge.js');
    controller?.runJavascript(jsFile);
  }

  void registerHandler(String handlerName, WebViewJSBridgeHandler handler) {
    _handlers[handlerName] = handler;
  }

  void removeHandler(String handlerName) {
    _handlers.remove(handlerName);
  }

  void _onMessageReceived(JavascriptMessage message) {
    final decodeStr = Uri.decodeFull(message.message);
    final jsonData = jsonDecode(decodeStr);
    final String type = jsonData['type'];
    debugPrint('WebViewJSBridge._onMessageReceived msg type $type');
    switch (type) {
      case 'request':
        _jsCall(jsonData);
        break;
      case 'response':
      case 'error':
        _nativeCallResponse(jsonData);
        break;
      default:
        break;
    }
  }

  Future<void> _jsCall(Map<String, dynamic> jsonData) async {
    if (jsonData.containsKey('handlerName')) {
      final String handlerName = jsonData['handlerName'];
      debugPrint(
          'WebViewJSBridge._jsCall handlerName $handlerName, ${_handlers.containsKey(handlerName)}');
      if (_handlers.containsKey(handlerName)) {
        _handlers[handlerName]?.call(jsonData['data']);
      } else {
        _jsCallError(jsonData);
      }
    } else {
      debugPrint('WebViewJSBridge._jsCall default handler handle');
      if (defaultHandler != null) {
        defaultHandler?.call(jsonData['data']);
      } else {
        _jsCallError(jsonData);
      }
    }
  }

  void _jsCallError(Map<String, dynamic> jsonData) {
    jsonData['type'] = 'error';
    _evaluateJavascript(jsonData);
  }

  Future<T?> callHandler<T extends Object?>(String handlerName,
      {Object? data}) async {
    return _nativeCall<T>(handlerName: handlerName, data: data);
  }

  Future<T?> send<T extends Object?>(Object data) async {
    return _nativeCall<T>(data: data);
  }

  Future<T?> _nativeCall<T extends Object?>(
      {String? handlerName, Object? data}) async {
    final jsonData = {
      'index': _completerIndex,
      'type': 'request',
    };
    if (data != null) {
      jsonData['data'] = data;
    }
    if (handlerName != null) {
      jsonData['handlerName'] = handlerName;
    }

    final completer = Completer<T>();
    _completerMap[_completerIndex] = completer;
    _completerIndex += 1;

    _evaluateJavascript(jsonData);
    return completer.future;
  }

  void _nativeCallResponse(Map<String, dynamic> jsonData) {
    final int index = jsonData['index'];
    final completer = _completerMap[index];
    _completerMap.remove(index);
    if (jsonData['type'] == 'response') {
      completer?.complete(jsonData['data']);
    } else {
      completer?.completeError('native call js error for request $jsonData');
    }
  }

  void _evaluateJavascript(Map<String, dynamic> jsonData) {
    final jsonStr = jsonEncode(jsonData);
    final encodeStr = Uri.encodeFull(jsonStr);
    debugPrint('WebViewJSBridge._evaluateJavascript jsonData $jsonStr');
    final script = 'WebViewJavascriptBridge.nativeCall("$encodeStr")';
    controller?.runJavascript(script);
  }
}
