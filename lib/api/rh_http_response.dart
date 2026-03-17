class RHHttpResponse {
  int code;
  String msg;
  dynamic? data;

  bool get isOK => code == 200;

  static const int errorCode = -1;

  RHHttpResponse({this.code = -1, this.msg = '', this.data});

  factory RHHttpResponse.fromJson(Map<String, dynamic> json) {
    int result = -1;
    result = json["code"] as int;
    String msg = json['msg'] ?? '';
    return RHHttpResponse(
        code: result,
        msg: msg,
        data: json["data"]
    );
  }

  @override
  String toString() {
    return "code:$code; msg: $msg; data: $data";
  }
}
