class GlobalOrderApiService {
  ///添加海外订单
  static const String addOverseaOrder = '/api/overseas/orders/add';

  ///查询订单列表
  static const String getOverseaOrderList = '/api/overseas/orders/list';

  ///查询订单详情
  static const String getOverseaOrderInfo = '/api/overseas/orders/query_info';

  ///取消订单
  static const String cancelOrder = '/api/overseas/orders/cancel';

  ///修改订单
  static const String editOrder = '/api/overseas/orders/edit';

  ///删除订单
  static const String deleteOrder = '/api/overseas/orders/del';

  ///订单确认收货
  static const String confirmReceive = '/api/overseas/orders/ok';

  ///去支付
  static const String orderPay = '/api/overseas/orders/pay';

  ///模糊查询订单（商品名称）
  static const String queryOrder = '/api/overseas/orders/query';

}
