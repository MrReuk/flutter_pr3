import 'package:dio/dio.dart';

import 'api_exceptions.dart';

class AuthSession {
  AuthSession({
    required this.username,
    required this.password,
    required Dio client,
  }) : _client = client;

  final String username;
  final String password;
  final Dio _client;

  String? _token;
  Future<void>? _pending;

  String? get token => _token;

  Future<void> ensureSignedIn() {
    if (_token != null) return Future<void>.value();
    return _pending ??= _signIn().whenComplete(() => _pending = null);
  }

  void forget() => _token = null;

  Future<void> _signIn() {
    return guard(() async {
      final response = await _client.post<dynamic>(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      final status = response.statusCode ?? 0;
      if (status >= 400) throw mapHttpError(status, response.data);
      final data = response.data;
      if (data is! Map || data['accessToken'] is! String) {
        throw const ServerException('Сервер не выдал токен доступа.');
      }
      _token = data['accessToken'] as String;
    });
  }
}
