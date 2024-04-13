import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ttcm_flutter_test/data/source/remote/interceptor/logger_interceptor.dart';

@lazySingleton
class RestSource {
  final Dio _dio;

  RestSource._(this._dio);

  @factoryMethod
  factory RestSource() {
    const connectionTimeout = Duration(seconds: 40);

    final baseOptions = BaseOptions(
      connectTimeout: connectionTimeout,
    );
    final dio = Dio(baseOptions);
    dio.interceptors.add(LoggerInterceptor());

    return RestSource._(dio);
  }

  Future<void> downloadFile({
    required String urlPath,
    required String downloadPath,
    required Function(int count, int total) onReceiveProgress,
    required Completer cancelCompleter,
  }) async {
    final cancelToken = CancelToken();
    cancelCompleter.future.then((value) => cancelToken.cancel());
    await _dio.download(
      urlPath,
      downloadPath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }
}
