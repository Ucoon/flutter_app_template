import 'dart:async';
import 'package:tobias/tobias.dart';

///支付宝支付工具类
class AliPayKit {
  static const String success = '9000'; //支付成功
  static late final AliPayKit _instance = AliPayKit._internal();
  factory AliPayKit() => _instance;
  late Tobias? _tobias;
  AliPayKit._internal(){
    _tobias = Tobias();
  }

  ///判断支付宝是否安装
  Future<bool?> get isAliPayInstalled async {
    return await _tobias?.isAliPayInstalled;
  }

  ///调起支付宝支付
  Future<bool> payByAliPay(String orderInfo) async {
    Map? resMap = await _tobias?.pay(orderInfo);
    return resMap?['resultStatus'] == success;
  }
}
