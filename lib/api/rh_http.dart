import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../base_tool/i18n.dart';
import '../base_tool/rh_cache.dart';
import '../base_tool/rh_datetime.dart';
import '../api/rh_http_response.dart';
import 'package:dio/src/response.dart' as dio;
import 'package:dio/src/form_data.dart' as fdDio;
import '../api/rh_urls.dart';
import '../base_tool/rh_null.dart';
import '../base_views/rh_toast.dart';


typedef IntCallback = void Function(int value);
typedef DoubleCallback = void Function(double value);
typedef BoolCallback = void Function(bool flag);
typedef StringCallback = void Function(String value);
typedef QueryCallback = void Function(bool isOK, String msg, dynamic data);
class RHHttp {
  static const int methodPost = 1;
  static const int methodGet = 2;
  static const int methodDelete = 4;
  static const int methodPicture = 6;

  static queryData({
    required String url,
    required QueryCallback callback,
    int mtd = methodPost,
    Map? params,
    fdDio.FormData? formData,
  }) async {
    params ??= {};
    Future<RHHttpResponse?> res;
    switch (mtd) {
      case methodPost:
        res = RHHttp.getMgr().post(url, body: params);
        break;
      case methodGet:
        res = RHHttp.getMgr().get(url, params: params);
        break;
      case methodPicture:
        res = RHHttp.getMgr().postPicture(url, formData: formData);
        break;
      default:
        res = RHHttp.getMgr().delete(url, body: params);
        break;
    }
    RHHttpResponse? result = await res;
    bool isOK = false;
    String msg = 'Net Error';
    dynamic data = '';
    if (result != null) {
      if (result.isOK) {
        isOK = true;
        data = result.data;
        msg = result.msg;
      }else {
        msg = result.msg;
        data = result.code;
      }
    }
    callback(isOK, msg, data);
  }

  Future<RHHttpResponse?> get(String url,
      {Map? params}) async {
    try {
      params ??= {};
      Map<String, dynamic> mpp = Map.from(params);
      mpp['languageId'] = 'en';
      final result = await httpConnect.get(url, queryParameters: mpp);
      return onHandlerResult(result);
    } on DioException catch (e) {
      return onHandlerError(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  static final RxString _urlFlag = RHUrls.baseUrl.obs;
  static void testNetSpeed() async {
    int flag = 0;
    Duration timeOut = const Duration(seconds: 20);
    Map<String, dynamic> stampMap = {};

    int startStamp = DateTime.now().secondsSinceEpoch;
    Future<void> testMethod(String baseUrl) async {
      var optCN = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeOut,
        receiveTimeout: timeOut,
      );
      optCN.contentType = Headers.jsonContentType;
      Dio httpDio = Dio(optCN);
      httpDio.interceptors.add(CustomInterceptors());
      try {
        dio.Response result = await httpDio.get(RHUrls.testSpeed);
        if (result.data['code'] == 200) {
          int endTime = DateTime.now().secondsSinceEpoch;
          stampMap[baseUrl] = 1+endTime-startStamp;
        }
        flag ++;
      } on DioException catch (e) {
        flag ++;
      } catch (e) {
        flag ++;
      }
    }

    // testMethod(RHUrls.baseUrl);
    void checkFlag() async {
      if (flag > 1) {
        // String localLang = Platform.localeName;
        // String local = localLang.split('_').last;
        // bool CN_Success = RHNull.getBool(stampMap[RHUrls.baseUrl]);
        // bool US_Success = RHNull.getBool(stampMap[RHUrls.baseUrl_US]);
        // print('testNetSpeed 0000 $local - $stampMap');
        // if (CN_Success && local == 'CN') {
        //   _urlFlag.value = RHUrls.baseUrl;
        //   print('testNetSpeed 1111 选 CN');
        // }else if (local == 'US' && US_Success) {
        //   _urlFlag.value = RHUrls.baseUrl_US;
        //   print('testNetSpeed 2222 选 US');
        // }else if (CN_Success) {
        //   _urlFlag.value = RHUrls.baseUrl;
        //   print('testNetSpeed 3333 选 CN');
        // }else {
        //   _urlFlag.value = RHUrls.baseUrl_US;
        //   print('testNetSpeed 4444 选 US');
        // }
        // // _urlFlag.value = 'http://43.136.69.79:8081/prod-api';//RHUrls.baseUrl_US;
        // RHCache.setValue(RHCache.requestURL, _urlFlag.value);
      }else {
        // Future.delayed(const Duration(seconds: 2), checkFlag);
      }
    }
    // checkFlag();
  }

  Future<RHHttpResponse?> post(String url,
      {
        Map? body,
        dynamic formData,
      }) async {
    try {
      if (body != null) {
        body['languageId'] = 'en';
      }
      print("发送POST请求111 ==> URL:$url, 参数:$body");
      var result = await httpConnect.post(url, data: body ?? formData);
      return onHandlerResult(result);
    } on DioException catch (e) {
      print('发送POST请求 error $e');
      return onHandlerError(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<RHHttpResponse?> postPicture(String url,
      {
        dynamic formData,
      }) async {
    try {
      print("发送format POST请求111 ==> URL:$url");
      var result = await uploadDio.post(url, data: formData);
      return onHandlerResult(result);
    } on DioException catch (e) {
      print('发送POST请求 error $e');
      return onHandlerError(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<RHHttpResponse?> delete(String url,
      {Map? body}) async {
    body ??= {};
    print("发送delete请求 ==> URL:$url, 参数:$body");
    var result = await httpConnect.delete(url, data: body);
    try {
      return onHandlerResult(result);
    } on DioException catch (e) {
      return onHandlerError(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<RHHttpResponse?> onHandlerError(DioException e) {
    switch (e.type) {
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
        return Future(() => RHHttpResponse(msg: "Connect time out"));
      case DioExceptionType.badResponse:
        return Future(() => RHHttpResponse(msg: "Server error."));
      case DioExceptionType.cancel:
        return Future(() => RHHttpResponse(msg: "Server error.."));
      case DioExceptionType.connectionError:
        return Future(() => RHHttpResponse(msg: "Server error..."));
      default:
        {
          return Future(() => RHHttpResponse(msg: "Server error!"));
        }
    }
  }

  Future<RHHttpResponse?> onHandlerResult(dio.Response<dynamic> res) {
    print('onHandlerResult【${res.data}】');
    RHHttpResponse resp = RHHttpResponse.fromJson(res.data);
    if (resp.code == 401) {
      RHToast.showToast(msg: 'login_tips_re_login');//  token过期，清理数据
    }else if (resp.code == 500) {

    }
    return Future(() => resp);
  }

  void updateToken() {
    Duration timeOut = const Duration(seconds: 12);
    String baseUrl = RHUrls.baseUrl;
    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeOut,
      receiveTimeout: timeOut,
    );
    options.contentType = Headers.jsonContentType;

    httpConnect = Dio(options);
    httpConnect.interceptors.add(CustomInterceptors());

    var options2 = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: timeOut,
    );
    options2.contentType = Headers.multipartFormDataContentType;
    uploadDio = Dio(options2);
    uploadDio.interceptors.add(CustomInterceptors());

    // Future.delayed(const Duration(seconds: 2), () {
    //   testNetSpeed();
    // });
  }

  static RHHttp? _instance = null;
  factory RHHttp.getMgr() {
    _instance ??= RHHttp._initHttp();
    return _instance!;
  }
  late Dio httpConnect;
  late Dio uploadDio;

  RHHttp._initHttp() {
    updateToken();
    ever(_urlFlag, (callback) {
      httpConnect.options.baseUrl = _urlFlag.value;
      uploadDio.options.baseUrl = _urlFlag.value;
    });
    // StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((List<ConnectivityResult> result) {
    //       if (result.isNotEmpty) {
    //         if (result.contains(ConnectivityResult.mobile)) {
    //           print('网络变化：mobile');
    //         } else if (result.contains(ConnectivityResult.wifi)) {
    //           print('网络变化：wifi');
    //         } else if (result.contains(ConnectivityResult.ethernet)) {
    //           print('网络变化：ethernet');
    //         } else if(result.contains(ConnectivityResult.bluetooth)) {
    //
    //         }
    //       }
    // });
  }
}

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('method[${options.method}] URL: ${options.uri}');

    String token = RHCache.getToken();
    if (token.isNotEmpty) {
      options.headers["Authorization"] = token;
      options.headers["languageId"] = 'en';
    }
    String auth = RHNull.getStr(options.headers["Authorization"]);
    if (auth.length > 20) {
      auth = auth.substring(auth.length-5, auth.length);
    }
    print("headers11内容：   ${options.headers["languageId"]}-[token:$auth]");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE:[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('http_ERROR [${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
