
import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  final Dio dio;
  LoggingInterceptor(this.dio);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("------ Request ${options.path} -------");
    log('REQUEST[${options.method}]');
    log('REQUEST[${options.headers}] ');
    log("End of Request -----------------------------");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("------ RESPONSE ${response.requestOptions.path} -------");
    log('RESPONSE -- ${response.statusCode}]');
    log('RESPONSE[${response}] ');
    log("End of RESPONSE -----------------------------");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    return super.onError(err, handler);
  }
}