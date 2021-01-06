import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/http/util/full_url.dart';
import 'package:stock_helper/http/http_config.dart';
import 'package:stock_helper/http/interceptor/interceptor_list.dart';
import 'package:stock_helper/http/util/http_error.dart';
import 'package:stock_helper/http/util/http_exception.dart';

class HttpUtil {
  static final HttpUtil _instance = new HttpUtil._internal();
  static const String GET = "get";
  static const String POST = "post";
  static const String UPLOAD = "upload";
  Dio _dio;
  BaseOptions _baseOption;
  factory HttpUtil() {
    return _instance;
  }

  HttpUtil._internal() {
    _baseOption = BaseOptions(
        contentType: HttpConfig.contentType.value,
        connectTimeout: HttpConfig.connectTimeout,
        receiveTimeout: HttpConfig.receiveTimeout,
        baseUrl: HttpConfig.baseUrl);
    _dio = new Dio(_baseOption);
    if (Config.debug) {
      addInterceptor(LogInterceptor());
    }
    addInterceptor(ErrorInterceptor());
  }
  addInterceptor(Interceptor interceptor) {
    if (null != _dio) {
      _dio.interceptors.add(interceptor);
    }
  }

  Dio getDio() {
    return _dio;
  }

  /// get
  Future<dynamic> get(String path, {Map<String, String> getParams}) {
    return request(path, GET, getParams: getParams);
  }

  /// post
  Future<dynamic> post(String path, postData) {
    return request(path, POST, postData: postData);
  }

  /// upload
  Future<dynamic> upload(String path, postData) {
    return request(path, UPLOAD, postData: postData);
  }

  Future<dynamic> request(String path, String mode,
      {postData, Map<String, String> getParams}) async {
    try {
      path = FullUrl.make(path, getParams);
      var resp;
      switch (mode) {
        case GET:
          resp = await _dio.get(path);
          break;
        case POST:
          resp = await _dio.post<Map<String, dynamic>>(path, data: postData);
          break;
        case UPLOAD:
          resp = await _dio.post(path, data: postData);
          break;
      }
      return resp.data['code'] != 0
          ? Future.error(HttpException(resp.data['code'], resp.data['msg']))
          : resp.data['data'];
    } on DioError catch (e) {
      int code = HttpError.UNKNOWN;
      if (e.response != null && e.response.statusCode != null) {
        code = e.response.statusCode;
      }
      return Future.error(HttpException(code, e.message));
    } catch (e) {
      return Future.error(HttpException(HttpError.EXCEPTION, e.toString()));
    }
  }
}
