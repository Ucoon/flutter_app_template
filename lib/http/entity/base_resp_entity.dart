import '../net_work.dart';

class BaseRespEntity<T> {
  BaseRespEntity({
    this.code = 0,
    this.message = '',
    this.data,
  });

  int code;
  String message;
  dynamic data;

  bool get succeed => code == RequestClient.httpSucceed;

  factory BaseRespEntity.fromJson(Map<String, dynamic> json) => BaseRespEntity(
    code: json["code"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data,
  };
}
