import 'dart:async';
import 'dart:developer';

import 'package:basketvibe/core/constants/app_constants.dart';
import 'package:basketvibe/core/services/secure_token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

const _kRetried = 'x-retried';

class DioNetwork {
  static late Dio appAPI;

  static bool _isRefreshing = false;
  static final List<void Function()> _queue = [];

  static void initDio() {
    assert(AppConstants.apiBaseUrl.isNotEmpty, 'API_BASE_URL not set in .env');
    appAPI = Dio(baseOptions(AppConstants.apiBaseUrl));
    appAPI.interceptors.add(_queuedInterceptor());
  }

  static QueuedInterceptorsWrapper _queuedInterceptor() {
    return QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await GetIt.instance<SecureTokenStorage>()
            .getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        if (kDebugMode) {
          log(
            '→ ${options.method} ${options.path} | auth: ${options.headers.containsKey('Authorization')}',
            name: 'DioNetwork',
          );
        }

        return handler.next(options);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        final statusCode = error.response?.statusCode;
        final alreadyRetried = error.requestOptions.extra[_kRetried] == true;

        if (statusCode == 401 && !alreadyRetried) {
          if (!_isRefreshing) {
            _isRefreshing = true;
            try {
              // TODO: call AuthRepository.refreshAccessToken() when implemented
              // For now, clear session and reject — cubit detects cleared tokens
              _isRefreshing = false;
              for (final cb in _queue) {
                cb();
              }
              _queue.clear();
              await _clearSession();
              return handler.reject(error);
            } catch (e, st) {
              log(
                'Token refresh error: $e',
                name: 'DioNetwork',
                stackTrace: st,
              );
              _isRefreshing = false;
              _queue.clear();
              await _clearSession();
              return handler.reject(error);
            }
          } else {
            await _addToQueue(error.requestOptions, handler);
            return;
          }
        }

        return handler.next(error);
      },
    );
  }

  static Future<void> _clearSession() async {
    await GetIt.instance<SecureTokenStorage>().clearTokens();
    log('Session cleared', name: 'DioNetwork');
  }

  static Future<void> _addToQueue(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    final completer = Completer<void>();
    _queue.add(() async {
      final token = await GetIt.instance<SecureTokenStorage>().getAccessToken();
      if (token != null) {
        requestOptions.headers['Authorization'] = 'Bearer $token';
        requestOptions.extra[_kRetried] = true;
        try {
          final response = await appAPI.fetch(requestOptions);
          handler.resolve(response);
        } catch (e) {
          log('Queued retry failed: $e', name: 'DioNetwork');
          handler.reject(
            DioException(requestOptions: requestOptions, error: e),
          );
        }
      } else {
        handler.reject(
          DioException(
            requestOptions: requestOptions,
            error: 'No valid access token',
          ),
        );
      }
      completer.complete();
    });
    return completer.future;
  }

  static BaseOptions baseOptions(String url) {
    return BaseOptions(
      baseUrl: url,
      connectTimeout: AppConstants.networkTimeout,
      receiveTimeout: AppConstants.networkTimeout,
      validateStatus: (status) => status != null && status < 300,
      responseType: ResponseType.json,
    );
  }
}
