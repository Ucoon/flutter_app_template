class BaseRespEntity<T> {
  BaseRespEntity({
    this.code = 0,
    this.success = false,
    this.data,
  });

  int code;
  bool success;
  dynamic data;

  factory BaseRespEntity.fromJson(Map<String, dynamic> json) => BaseRespEntity(
        code: json["code"],
        success: json["success"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": data,
      };
}
