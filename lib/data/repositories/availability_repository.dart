import 'package:intl/intl.dart';

import '../../models/availability.dart';
import '../api/api_client.dart';

/// Free slots for a service on a day.
class AvailabilityRepository {
  const AvailabilityRepository(this._client);

  static final DateFormat _date = DateFormat('yyyy-MM-dd');

  final ApiClient _client;

  /// [stylistId] omitted means "any stylist who performs this service" —
  /// a real choice the client offers, not a missing value.
  Future<Availability> forDay({
    required String serviceId,
    required DateTime date,
    String? stylistId,
  }) async {
    final json = await _client.get<Map<String, dynamic>>(
      '/availability',
      skipAuth: true,
      query: {
        'serviceId': serviceId,
        'date': _date.format(date),
        'stylistId': ?stylistId,
      },
    );
    return Availability.fromJson(json);
  }
}
