import 'dart:math';
import '../../http/net_cancel_scope.dart';
import '../../http/net_work.dart';
import 'base_i_model.dart';

///基础数据仓库层
class BaseModel implements IModel {
  late RequestClient _apiService;
  String? tag;
  final CancelScope _cancelScope = CancelScope();

  BaseModel() {
    _apiService = RequestClient();
    tag = _randomBit(100);
    _cancelScope.key = tag;
    _apiService.cancelScope = _cancelScope;

  }

  @override
  void onClear() {
    // _cancelScope.cancel(tag!);
  }

  ///获取随机数
  String _randomBit(int len) {
    String scopeF = '123456789'; //首位
    String scopeC = '0123456789'; //中间
    String result = '';
    for (int i = 0; i < len; i++) {
      if (i == 0) {
        result = scopeF[Random().nextInt(scopeF.length)];
      } else {
        result = result + scopeC[Random().nextInt(scopeC.length)];
      }
    }
    return result;
  }

  RequestClient get apiService => _apiService;
}
