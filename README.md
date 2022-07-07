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
  		|- widget/		# 当前模块widget
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
