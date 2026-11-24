import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the access and refresh tokens live.
///
/// Keychain on iOS, EncryptedSharedPreferences on Android — not
/// `shared_preferences`, which is plain text on disk and would hand a
/// stylist's session to anyone with the device.
class TokenStore {
  const TokenStore(this._storage);

  factory TokenStore.standard() => const TokenStore(
    FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );

  static const String _accessKey = 'ff_access_token';
  static const String _refreshKey = 'ff_refresh_token';

  final FlutterSecureStorage _storage;

  Future<String?> readAccessToken() => _storage.read(key: _accessKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  Future<void> saveAccessToken(String accessToken) =>
      _storage.write(key: _accessKey, value: accessToken);

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  Future<bool> get hasSession async =>
      (await readRefreshToken())?.isNotEmpty ?? false;
}
