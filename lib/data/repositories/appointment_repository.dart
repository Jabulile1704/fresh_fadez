import '../../models/appointment.dart';
import '../api/api_client.dart';

/// Reading and changing bookings.
class AppointmentRepository {
  const AppointmentRepository(this._client);

  final ApiClient _client;

  Future<List<Appointment>> list() async {
    final json = await _client.get<dynamic>('/appointments');
    final raw = json is Map<String, dynamic> ? json['appointments'] : json;
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(Appointment.fromJson)
        .toList();
  }

  /// Books a slot.
  ///
  /// Throws an ApiException with `code == slotTaken` when somebody else got
  /// there first. That is an expected outcome of a busy salon, not a bug —
  /// the booking screen re-fetches and asks again.
  Future<Appointment> create({
    required String serviceId,
    required DateTime startsAt,
    String? stylistId,
    String? notes,
  }) async {
    final json = await _client.post<Map<String, dynamic>>(
      '/appointments',
      body: {
        'serviceId': serviceId,
        'startsAt': startsAt.toUtc().toIso8601String(),
        'stylistId': ?stylistId,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    return _one(json);
  }

  /// Moves an existing booking. Carries the same no-double-booking guarantee
  /// as [create] — the server will not release the old slot until the new
  /// one is held.
  Future<Appointment> reschedule({
    required String id,
    required DateTime startsAt,
    String? stylistId,
  }) async {
    final json = await _client.patch<Map<String, dynamic>>(
      '/appointments/$id',
      body: {
        'startsAt': startsAt.toUtc().toIso8601String(),
        'stylistId': ?stylistId,
      },
    );
    return _one(json);
  }

  Future<Appointment> cancel({required String id, String? reason}) async {
    final json = await _client.post<Map<String, dynamic>>(
      '/appointments/$id/cancel',
      body: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    );
    return _one(json);
  }

  Appointment _one(Map<String, dynamic> json) {
    final nested = json['appointment'];
    return Appointment.fromJson(nested is Map<String, dynamic> ? nested : json);
  }
}
