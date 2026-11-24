import '../../models/app_user.dart';
import '../api/api_client.dart';
import '../api/token_store.dart';

/// Sign in, sign up, and everything that touches a session.
class AuthRepository {
  const AuthRepository({required ApiClient client, required TokenStore tokens})
    : _client = client,
      _tokens = tokens;

  final ApiClient _client;
  final TokenStore _tokens;

  Future<AppUser> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final json = await _client.post<Map<String, dynamic>>(
      '/auth/register',
      skipAuth: true,
      body: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
    return _persist(json);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final json = await _client.post<Map<String, dynamic>>(
      '/auth/login',
      skipAuth: true,
      body: {'email': email, 'password': password},
    );
    return _persist(json);
  }

  /// The signed-in user, or `null` when there is no usable session.
  ///
  /// Called on launch. A failure here is not an error the user should see —
  /// it just means "show the login screen".
  Future<AppUser?> currentUser() async {
    if (!await _tokens.hasSession) {
      return null;
    }
    try {
      final json = await _client.get<Map<String, dynamic>>('/auth/me');
      return AppUser.fromJson(_userOf(json));
    } on Object {
      await _tokens.clear();
      return null;
    }
  }

  Future<void> logout() async {
    final refreshToken = await _tokens.readRefreshToken();
    try {
      if (refreshToken != null) {
        await _client.post<dynamic>(
          '/auth/logout',
          body: {'refreshToken': refreshToken},
        );
      }
    } on Object {
      // Signing out locally must succeed even if the server cannot be told.
    } finally {
      await _tokens.clear();
    }
  }

  Future<void> requestPasswordReset(String email) => _client.post<dynamic>(
    '/auth/forgot-password',
    skipAuth: true,
    body: {'email': email},
  );

  Future<void> resetPassword({
    required String token,
    required String password,
  }) => _client.post<dynamic>(
    '/auth/reset-password',
    skipAuth: true,
    body: {'token': token, 'password': password},
  );

  Future<AppUser> _persist(Map<String, dynamic> json) async {
    final session = AuthSession.fromJson(json);
    await _tokens.save(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    return session.user;
  }

  /// `/auth/me` returns the user either bare or wrapped in `{ user: … }`.
  Map<String, dynamic> _userOf(Map<String, dynamic> json) {
    final nested = json['user'];
    return nested is Map<String, dynamic> ? nested : json;
  }
}
