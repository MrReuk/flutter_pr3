import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exceptions.dart';
import 'auth_session.dart';
import 'config.dart';

const List<Duration> kRetryDelays = [
  Duration(milliseconds: 600),
  Duration(milliseconds: 1500),
];

Dio buildDio({
  String? baseUrl,
  String? Function()? tokenProvider,
  AuthSession? session,
  HttpClientAdapter? adapter,
  List<Duration> retryDelays = kRetryDelays,
  Map<String, String> debugFlags = const {},
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) => status != null && status < 500,
    ),
  );
  if (adapter != null) dio.httpClientAdapter = adapter;

  dio.interceptors.add(_AuthInterceptor(session: session, tokenProvider: tokenProvider));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra['startedAt'] = DateTime.now().millisecondsSinceEpoch;
        if (debugFlags.isNotEmpty) options.queryParameters.addAll(debugFlags);
        return handler.next(options);
      },
      onResponse: (response, handler) {
        final status = response.statusCode ?? 0;
        _log(response.requestOptions, '$status');
        if (status >= 400) {
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
              error: mapHttpError(status, response.data),
            ),
            true,
          );
        }
        return handler.next(response);
      },
      onError: (error, handler) {
        if (error.error is! ApiException) {
          final status = error.response?.statusCode;
          _log(error.requestOptions, status == null ? error.type.name : '$status');
        }
        return handler.next(error);
      },
    ),
  );

  dio.interceptors.add(
    _RecoveryInterceptor(dio: dio, session: session, delays: retryDelays),
  );

  return dio;
}

Dio buildLoginDio({String? baseUrl, HttpClientAdapter? adapter}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) => status != null && status < 500,
    ),
  );
  if (adapter != null) dio.httpClientAdapter = adapter;
  return dio;
}

void _log(RequestOptions options, String outcome) {
  if (!kDebugMode) return;
  final started = options.extra['startedAt'];
  final elapsed = started is int
      ? ' ${DateTime.now().millisecondsSinceEpoch - started} мс'
      : '';
  debugPrint('[API] ${options.method} ${options.uri} → $outcome$elapsed');
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor({required this.session, required this.tokenProvider});

  final AuthSession? session;
  final String? Function()? tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuthCall = options.path.startsWith('/auth/');
    final current = session;

    if (!isAuthCall && current != null && options.method.toUpperCase() != 'GET') {
      try {
        await current.ensureSignedIn();
      } on ApiException catch (e) {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: e,
            type: DioExceptionType.unknown,
          ),
          true,
        );
      }
    }

    final token = current?.token ?? tokenProvider?.call();
    if (token != null && !isAuthCall) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}

class _RecoveryInterceptor extends Interceptor {
  _RecoveryInterceptor({
    required this.dio,
    required this.session,
    required this.delays,
  });

  final Dio dio;
  final AuthSession? session;
  final List<Duration> delays;

  bool _isNetworkFailure(DioException error) {
    if (error.response != null) return false;
    return switch (error.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        true,
      _ => false,
    };
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.cancel) return handler.next(err);

    final options = err.requestOptions;
    final current = session;

    if (err.response?.statusCode == 401 &&
        current != null &&
        !options.path.startsWith('/auth/') &&
        options.extra['reauthorized'] != true) {
      current.forget();
      options.extra['reauthorized'] = true;
      try {
        await current.ensureSignedIn();
      } on ApiException catch (e) {
        return handler.next(
          DioException(
            requestOptions: options,
            error: e,
            type: DioExceptionType.unknown,
          ),
        );
      }
      return _replay(options, handler);
    }

    final attempt = (options.extra['retryAttempt'] as int?) ?? 0;
    if (options.method.toUpperCase() == 'GET' &&
        _isNetworkFailure(err) &&
        attempt < delays.length) {
      await Future<void>.delayed(delays[attempt]);
      options.extra['retryAttempt'] = attempt + 1;
      return _replay(options, handler);
    }

    return handler.next(err);
  }

  Future<void> _replay(
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final response = await dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }
}
