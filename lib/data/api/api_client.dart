import 'dart:async';

import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'token_store.dart';

/// Where the API lives.
///
/// Overridable at build time so a debug build can point at a laptop and a
/// release build at Render:
/// `flutter run --dart-define=FF_API_BASE_URL=http://10.0.2.2:4000`
class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'FF_API_BASE_URL',
    defaultValue: 'http://localhost:4000',
  );
}

/// The HTTP client every repository goes through.
///
/// Attaches the access token, and on a 401 refreshes once and replays the
/// request. Concurrent 401s share a single refresh — without that, five
/// screens loading at once would fire five refreshes and four of them would
/// race to invalidate each other's rotated token.
class ApiClient {
  ApiClient({required TokenStore tokenStore, Dio? dio, this.onSessionExpired})
    : _tokenStore = tokenStore,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              contentType: Headers.jsonContentType,
              // We read the body ourselves for every status, so Dio should
              // not throw before ApiException gets a look at the envelope.
              validateStatus: (status) => status != null && status < 500,
            ),
          ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  final Dio _dio;
  final TokenStore _tokenStore;

  /// Called when the refresh token itself is dead and the user must sign in
  /// again. The shell listens to this and routes to login.
  final void Function()? onSessionExpired;

  Future<void>? _refreshInFlight;

  Dio get raw => _dio;

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] != true) {
      final token = await _tokenStore.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  /// `validateStatus` lets 4xx through, so turn those into errors here.
  void _onResponse(Response<dynamic> response, ResponseInterceptorHandler h) {
    final status = response.statusCode ?? 0;
    if (status >= 400) {
      h.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
      );
      return;
    }
    h.next(response);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final status = error.response?.statusCode;
    final options = error.requestOptions;
    final alreadyRetried = options.extra['retried'] == true;
    final isAuthCall = options.extra['skipAuth'] == true;

    if (status != 401 || alreadyRetried || isAuthCall) {
      handler.next(error);
      return;
    }

    final refreshed = await _refreshOnce();
    if (!refreshed) {
      await _tokenStore.clear();
      onSessionExpired?.call();
      handler.next(error);
      return;
    }

    try {
      options.extra['retried'] = true;
      final token = await _tokenStore.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      final replay = await _dio.fetch<dynamic>(options);
      handler.resolve(replay);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// Refreshes the access token, collapsing concurrent callers onto one call.
  Future<bool> _refreshOnce() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      return inFlight.then((_) async {
        final token = await _tokenStore.readAccessToken();
        return token != null && token.isNotEmpty;
      });
    }

    final completer = Completer<void>();
    _refreshInFlight = completer.future;

    return () async {
      var ok = false;
      try {
        final refreshToken = await _tokenStore.readRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          return false;
        }
        final response = await _dio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
          options: Options(extra: {'skipAuth': true}),
        );
        final body = response.data;
        final access = body?['accessToken'] as String?;
        final refresh = body?['refreshToken'] as String?;
        if (access == null) {
          return false;
        }
        if (refresh != null) {
          await _tokenStore.save(accessToken: access, refreshToken: refresh);
        } else {
          await _tokenStore.saveAccessToken(access);
        }
        ok = true;
        return true;
      } on DioException {
        return false;
      } finally {
        _refreshInFlight = null;
        completer.complete();
        if (!ok) {
          // nothing more to do; caller clears the session
        }
      }
    }();
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    bool skipAuth = false,
  }) => _send<T>(
    () => _dio.get<T>(
      path,
      queryParameters: query,
      options: Options(extra: {'skipAuth': skipAuth}),
    ),
  );

  Future<T> post<T>(String path, {Object? body, bool skipAuth = false}) =>
      _send<T>(
        () => _dio.post<T>(
          path,
          data: body,
          options: Options(extra: {'skipAuth': skipAuth}),
        ),
      );

  Future<T> patch<T>(String path, {Object? body}) =>
      _send<T>(() => _dio.patch<T>(path, data: body));

  Future<void> delete(String path) =>
      _send<void>(() => _dio.delete<void>(path));

  Future<T> _send<T>(Future<Response<T>> Function() call) async {
    try {
      final response = await call();
      return response.data as T;
    } on DioException catch (error) {
      throw ApiException.from(error);
    }
  }
}
