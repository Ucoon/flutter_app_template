class PersonalApiService {
  ///获取用户信息
  static const String userInfo = '/api/user/info';

  ///修改用户信息
  static const String updateUserInfo = '/api/user/update_info';

  ///退出登录
  static const String userExitLogin = '/user/login/logout';

  ///注销
  static const String userReg = '/user/login/logout';

  ///获取用户通知设置信息
  static const String userGetNotice = '/api/user/get_notice';

  ///修改用户通知设置状态
  static const String userUpdateNotice = '/api/user/update_notice';

  ///获取用户帮助中心列表
  static const String userGetHelp = '/api/user/get_help';

  ///用户是否实名认证
  static const String userIsReal = '/api/user/if_real';

  ///用户提交实名认证申请
  static const String userAddRealName = '/api/user/add_real_name';

  ///获取用户实名认证信息
  static const String userRealNameDate = '/api/user/real_name_data';

  ///修改、重新提交，用户实名认证信息
  static const String editUserRealName = '/api/user/edit_real_name';

  ///订单类型数量
  static const String getOrderTypeNum = '/api/order/get_type_num';

  ///查询分销商申请状态
  static const String checkDistributor = '/api/distributor/check';
  
}
