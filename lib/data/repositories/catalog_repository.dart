import '../../models/salon.dart';
import '../../models/service.dart';
import '../../models/stylist.dart';
import '../api/api_client.dart';

/// Services, stylists and the salon's own details and rules.
class CatalogRepository {
  const CatalogRepository(this._client);

  final ApiClient _client;

  Future<List<Service>> services() async {
    final json = await _client.get<dynamic>('/services', skipAuth: true);
    return _listOf(json, 'services').map(Service.fromJson).toList();
  }

  Future<List<Stylist>> stylists({String? serviceId}) async {
    final json = await _client.get<dynamic>(
      '/stylists',
      skipAuth: true,
      query: serviceId == null ? null : {'serviceId': serviceId},
    );
    return _listOf(json, 'stylists').map(Stylist.fromJson).toList();
  }

  Future<Stylist> stylist(String id) async {
    final json = await _client.get<Map<String, dynamic>>(
      '/stylists/$id',
      skipAuth: true,
    );
    final nested = json['stylist'];
    return Stylist.fromJson(nested is Map<String, dynamic> ? nested : json);
  }

  Future<SalonInfo> salon() async {
    final json = await _client.get<Map<String, dynamic>>(
      '/salon',
      skipAuth: true,
    );
    return SalonInfo.fromJson(json);
  }

  /// Accepts either a bare array or `{ "<key>": [...] }`, so a later change
  /// to the envelope does not break the app.
  List<Map<String, dynamic>> _listOf(dynamic json, String key) {
    final raw = json is Map<String, dynamic> ? json[key] : json;
    if (raw is! List) {
      return const [];
    }
    return raw.whereType<Map<String, dynamic>>().toList();
  }
}
