class ResponseException implements Exception {
  final int? code;
  final String? msg;

  ResponseException({this.code, this.msg});

  @override
  String toString() {
    if (msg == null) return "Exception";
    return "$msg";
  }
}
