import 'package:conferance_application/config/constant/nums.dart';
import 'package:conferance_application/data/repositories/interceptor/error_interceptor.dart';
import 'package:conferance_application/utils/constant_static.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ConstantStatic.baseUrl,
      receiveTimeout: const Duration(seconds: apiTimeOut),
      connectTimeout: const Duration(seconds: apiTimeOut),
      sendTimeout: const Duration(seconds: apiTimeOut),
    ));
    dio.interceptors.addAll({
      // LoggingInterceptor(dio),
      PrettyDioLogger(requestBody: true,
        requestHeader: true,
        request: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
      ErrorInterceptors(dio)
    });
  }

  // 🔥 Call this whenever environment switches
  void refreshBaseUrl() {
    dio.options.baseUrl = ConstantStatic.baseUrl;
  }
}