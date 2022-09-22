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

# 已接入的第三方SDK：

1. 第三方授权登录：

   - `google_sign_in`：google登录(https://pub.dev/packages/google_sign_in)
   - `sign_in_with_apple`：apple登录(https://pub.dev/packages/sign_in_with_apple)
   - `flutter_login_facebook`：Facebook登录(https://pub.dev/packages/flutter_login_facebook)

   具体实现可参考`third_plateform_login.dart`

2. 微信相关：

   - `fluwx`：包括登录、分享、支付

   具体实现可参考`wechat_kit.dart`

3. 阿里云推送：

   `rammus`：
