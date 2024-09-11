import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/routes/app_pages.dart';
import 'common/langs/translation_service.dart';
import 'common/utils/utils.dart';
import 'global.dart';
import 'initial_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  //强制竖屏
  StatusBarKit.setPortrait().then((_) {
    runApp(const MyApp());
  });
}

Future<void> initServices() async {
  debugPrint('starting services ...');
  await Global.init();
  debugPrint('All services started...');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13尺寸
      builder: ([BuildContext? _, __]) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.cupertino,

          // 日志
          enableLog: true,
          logWriterCallback: Logger.write,
          // 路由
          getPages: AppPages.routes,
          navigatorObservers: [Global.routeObserver],
          // 启动页面
          initialRoute: AppPages.initial,
          initialBinding: InitialBinding(),
          // 多语言设置
          locale: TranslationService.locale, //刚进入App时，默认显示语言
          fallbackLocale: TranslationService.fallbackLocale, //语言选择无效时，备用语言
          translations: TranslationService(), //配置显示国际化内容
          builder: (context, widget) {
            return MediaQuery(
              ///设置文字大小不随系统设置改变
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: FlutterEasyLoading(child: widget),
            );
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            //一定要配置,否则iphone手机长按编辑框有白屏卡着的bug出现
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('zh', 'CN'),
          ],
        );
      },
    );
  }
}
