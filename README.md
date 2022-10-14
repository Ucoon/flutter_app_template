# flutter_app_template

基于[GetX](https://pub.dev/packages/get)的Flutter开发模板

项目结构：

```yaml
android/ 		# 安卓工程
ios/     		# ios工程
lib/
  |- app/		# app模块
    |- base/	# base模块
      |- controller/   # 基础逻辑处理类
      |- model/		# 基础结构体
    |- middleware/    # 路由中间件
    |- modules/		# 各功能模块
      |- bindings/	# 依赖
      |- controllers/	# 逻辑处理
      |- model/		# request和response的model
      |- views/		# 当前模块UI页面
      |- widget/	# 当前模块widget
      |- index
    |- routes/		# 路由表
  |- common/
    |- extensions/ 	 # 扩展方法
    |- lang/          # 语言库
    |- utils/		# 常用的工具类
    |- values/		# 常量值
  |- http/		    # dio封装
    |- entity/	   	# base结构体
    |- interceptor/	# 常用拦截器 
  |- widget/			# 常用的UI组件
  |- global			# 第三方appId初始化及全局配置
  |- initial_binding # 全局依赖
  |- main			# 入口文件
pubspec.yaml		# 配置文件

```



# 实用库：

- [GetX(路由、状态管理工具)](https://pub.dev/packages/get)

- [dio (非常好用的网络请求库)](https://pub.dev/packages/dio)

- [flutter_screenutil(屏幕适配库)](https://pub.dev/packages/flutter_screenutil)

- [flutter_easyrefresh(刷新组件)](https://pub.dev/packages/flutter_easyrefresh)

- [flutter_easyloading(加载框)](https://pub.dev/packages/flutter_easyloading)

- [shared_preferences](https://pub.dev/packages/shared_preferences)

- [device_info_plus(设备信息)](https://pub.dev/packages/device_info_plus)

- [package_info_plus(应用包信息)](https://pub.dev/packages/package_info_plus)

- [permission_handler 权限申请](https://pub.dev/packages/permission_handler)

- [gallery_saver(照片保存组件)](https://pub.dev/packages/gallery_saver)

- [image_gallery_saver(图片下载组件)](https://pub.dev/packages/image_gallery_saver)

- [image_cropper(照片裁剪组件)](https://pub.dev/packages/image_cropper)

- [video_compress(视频压缩组件)](https://pub.dev/packages/video_compress)

- [flutter_image_compress(图片压缩组件)](https://pub.dev/packages/flutter_image_compress)

- [wechat_assets_picker(资源选择器)](https://pub.dev/packages/wechat_assets_picker)

- [wechat_camera_picker(相机选择器)](https://pub.dev/packages/wechat_camera_picker)

- [cached_network_image (网络缓存图片)](https://pub.dev/packages/cached_network_image)

- [flutter_cache_manager(缓存管理库)](https://pub.dev/packages/flutter_cache_manager)

- [waterfall_flow(瀑布流布局)](https://pub.dev/packages/waterfall_flow)

- [photo_view(图片放大)](https://pub.dev/packages/photo_view)

- [webview_flutter(webView组件)](https://pub.dev/packages/webview_flutter)

- [android_id(Android设备唯一值获取)](https://pub.dev/packages/android_id)

- [carousel_pro_nullsafety(轮播图组件)](https://pub.dev/packages/carousel_pro_nullsafety)

- [flutter_app_badger(app角标组件)](https://pub.dev/packages/flutter_app_badger)

- [flutter_rating_bar(星级组件)](https://pub.dev/packages/flutter_rating_bar)

- [flutter_html(h5富文本组件)](https://pub.dev/packages/flutter_html)

  

# 已接入的第三方SDK：

1. 第三方授权登录：

   - `google_sign_in`：google登录(https://pub.dev/packages/google_sign_in)
   - `sign_in_with_apple`：apple登录(https://pub.dev/packages/sign_in_with_apple)
   - `flutter_login_facebook`：Facebook登录(https://pub.dev/packages/flutter_login_facebook)

   具体实现可参考`third_plateform_login.dart`

2. 微信相关：

   - `fluwx`：包括登录、分享、支付(https://pub.dev/packages/fluwx)

   具体实现可参考`wechat_kit.dart`

3. 阿里云推送：

   `rammus`：https://pub.dev/packages/rammus

   具体实现可参考`ali_push_kit.dart`

4. 美团多渠道打包：

   `package_by_walle`：https://pub.dev/packages/package_by_walle

# 已集成的功能：

1. 应用内升级：https://pub.dev/packages/kooboo_flutter_app_upgrade

   具体实现可参考：`app_upgrade_util.dart`
