import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:rammus/rammus.dart' as rammus;

///阿里云推送工具类
class AliPushKit {
  static late final AliPushKit _instance = AliPushKit._internal();
  factory AliPushKit() => _instance;
  AliPushKit._internal();

  ///初始化
  void initAliPush() {
    rammus.register();
    setupAndroidNotificationChannels();
    setupIOSNotificationPresentationOption();
    onNotificationListener();
  }

  ///设置通知渠道（针对Android 8.0以上）
  void setupAndroidNotificationChannels() {
    List<rammus.NotificationChannel> channels = <rammus.NotificationChannel>[];
    channels.add(const rammus.NotificationChannel(
      'chat_message_notice',
      '消息提醒',
      '消息提醒',
      importance: rammus.AndroidNotificationImportance.MAX,
    ));
    rammus.setupNotificationManager(channels);
  }

  ///设置iOS通知显示方式
  void setupIOSNotificationPresentationOption() {
    if (Platform.isIOS) {
      rammus.configureNotificationPresentationOption();
    }
  }

  ///获取设备id
  Future<String?> getAliPushDeviceId() {
    return rammus.deviceId;
  }

  void onNotificationListener() {
    rammus.initCloudChannelResult.listen((data) {
      debugPrint(
          "----------->init successful ${data.isSuccessful} ${data.errorCode} ${data.errorMessage}");
    });
    rammus.onNotification.listen((data) {
      debugPrint(
          'AliPushKit.onNotificationListener onNotification ${data.summary} ${data.extras} ${data.title}');
      _onNotification(json.encode(data.extras));
    });
    rammus.onNotificationOpened.listen((data) {
      debugPrint(
          'AliPushKit.onNotificationListener onNotificationOpened ${data.summary} ${data.extras} 被点了');
      _onNotificationOpened(data.extras ?? '');
    });

    rammus.onNotificationRemoved.listen((data) {
      debugPrint(
          'AliPushKit.onNotificationListener onNotificationRemoved $data 被删除了');
    });

    rammus.onNotificationReceivedInApp.listen((data) {
      debugPrint(
          'AliPushKit.onNotificationListener onNotificationReceivedInApp ${data.summary} In app');
    });

    rammus.onNotificationClickedWithNoAction.listen((data) {
      debugPrint(
          'AliPushKit.onNotificationListener onNotificationClickedWithNoAction "${data.summary} no action');
    });

    rammus.onMessageArrived.listen((data) {
      debugPrint(
          'AliPushKit.onNotificationListener onMessageArrived -> ${data.content}');
    });
  }

  void _onNotification(String extras) {
    if (isBlank(extras)) return;
  }

  void _onNotificationOpened(String extras) {
    if (isBlank(extras)) return;
  }
}
