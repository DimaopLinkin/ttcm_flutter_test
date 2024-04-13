import 'package:dio/dio.dart';
import 'package:ttcm_flutter_test/logger.dart';

class LoggerInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    logger.d(
      {
        "path": "${options.method} ${options.baseUrl}${options.path}",
        "data": options.data,
        "queryParams": options.queryParameters,
        "headers": options.headers,
      },
    );
    return handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    logger.d(
      {
        "path": "${response.requestOptions.method} ${response.requestOptions.baseUrl}${response.requestOptions.path}",
        if (response.statusCode != null) "statusCode": response.statusCode,
        if (response.data != null) "data": response.data,
      },
    );
    return handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e(
      {
        'message': err.message,
        'path': "${err.requestOptions.method} ${err.requestOptions.baseUrl}${err.requestOptions.path}",
        if (err.requestOptions.data != null) "data": err.requestOptions.data,
        "queryParams": err.requestOptions.queryParameters,
        "headers": err.requestOptions.headers,
      },
    );
    return handler.next(err);
  }
}
