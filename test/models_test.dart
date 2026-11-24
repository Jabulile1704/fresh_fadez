import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_fadez/models/app_user.dart';
import 'package:fresh_fadez/models/appointment.dart';
import 'package:fresh_fadez/models/availability.dart';
import 'package:fresh_fadez/models/service.dart';

/// These parse the exact JSON the API's `serialize.ts` emits. If the server
/// changes a field name, this is where it should fail — not three screens
/// deep at runtime.
void main() {
  group('Service', () {
    test('parses servicePublic', () {
      final service = Service.fromJson(const {
        'id': 's1',
        'name': 'Hair Cutting',
        'description': 'Cut and style',
        'category': 'Hair Services',
        'priceCents': 4500,
        'durationMinutes': 45,
        'imageAsset': null,
        'active': true,
      });

      expect(service.id, 's1');
      expect(service.priceCents, 4500);
      expect(service.formattedDuration, '45min');
    });

    test('formats durations over an hour', () {
      Service at(int minutes) => Service(
        id: 'x',
        name: 'x',
        category: 'x',
        priceCents: 0,
        durationMinutes: minutes,
      );

      expect(at(60).formattedDuration, '1h');
      expect(at(90).formattedDuration, '1h 30min');
      expect(at(45).formattedDuration, '45min');
    });
  });

  group('AppUser', () {
    test('maps the role enum from the wire', () {
      final owner = AppUser.fromJson(const {
        'id': 'u1',
        'email': 'o@example.com',
        'fullName': 'Owner Person',
        'phone': '',
        'role': 'OWNER',
      });

      expect(owner.role, UserRole.owner);
      expect(owner.role.isStaff, isTrue);
      expect(owner.firstName, 'Owner');
    });

    test('defaults to client', () {
      final user = AppUser.fromJson(const {
        'id': 'u2',
        'email': 'c@example.com',
        'fullName': 'Client Person',
      });

      expect(user.role, UserRole.client);
      expect(user.role.isStaff, isFalse);
    });
  });

  group('Appointment', () {
    Map<String, dynamic> payload(String status, String startsAt) => {
      'id': 'a1',
      'status': status,
      'startsAt': startsAt,
      'endsAt': startsAt,
      'durationMinutes': 45,
      'priceCents': 4500,
      'serviceId': 's1',
      'stylistId': 'st1',
      'userId': 'u1',
    };

    test('parses the status enum', () {
      final appointment = Appointment.fromJson(
        payload('NO_SHOW', '2027-01-01T10:00:00.000Z'),
      );

      expect(appointment.status, AppointmentStatus.noShow);
      expect(appointment.status.label, 'NO SHOW');
      expect(appointment.status.isLive, isFalse);
    });

    test('a future confirmed booking is upcoming, a past one is not', () {
      final future = DateTime.now().add(const Duration(days: 2)).toUtc();
      final past = DateTime.now().subtract(const Duration(days: 2)).toUtc();

      final upcoming = Appointment.fromJson(
        payload('CONFIRMED', future.toIso8601String()),
      );
      final previous = Appointment.fromJson(
        payload('CONFIRMED', past.toIso8601String()),
      );

      expect(upcoming.isUpcoming, isTrue);
      expect(upcoming.isPast, isFalse);
      expect(previous.isUpcoming, isFalse);
      expect(previous.isPast, isTrue);
    });

    test('a cancelled booking is never upcoming', () {
      final future = DateTime.now().add(const Duration(days: 2)).toUtc();
      final cancelled = Appointment.fromJson(
        payload('CANCELLED', future.toIso8601String()),
      );

      expect(cancelled.isUpcoming, isFalse);
      expect(cancelled.isCancelled, isTrue);
    });

    test('copyWith is available for optimistic updates', () {
      final appointment = Appointment.fromJson(
        payload('PENDING', '2027-01-01T10:00:00.000Z'),
      );
      final cancelled = appointment.copyWith(
        status: AppointmentStatus.cancelled,
      );

      expect(cancelled.status, AppointmentStatus.cancelled);
      expect(cancelled.id, appointment.id);
      expect(appointment.status, AppointmentStatus.pending);
    });
  });

  group('Availability', () {
    test('parses the envelope and splits morning from afternoon', () {
      final availability = Availability.fromJson(const {
        'date': '2027-01-04',
        'service': {
          'id': 's1',
          'name': 'Hair Cutting',
          'durationMinutes': 45,
          'priceCents': 4500,
        },
        'slots': [
          {
            'startsAt': '2027-01-04T06:00:00.000Z',
            'endsAt': '2027-01-04T06:45:00.000Z',
            'stylistIds': ['st1'],
          },
          {
            'startsAt': '2027-01-04T12:00:00.000Z',
            'endsAt': '2027-01-04T12:45:00.000Z',
            'stylistIds': ['st1', 'st2'],
          },
        ],
        'reason': null,
        'rules': {
          'slotStepMinutes': 15,
          'leadTimeMinutes': 60,
          'maxDaysAhead': 60,
        },
      });

      expect(availability.slots, hasLength(2));
      expect(availability.isEmpty, isFalse);
      expect(availability.reason, isNull);
      expect(availability.rules.leadTimeMinutes, 60);
      expect(availability.morning.length + availability.afternoon.length, 2);
      expect(availability.slots.last.stylistIds, ['st1', 'st2']);
    });

    test('carries a reason when there is nothing to offer', () {
      final availability = Availability.fromJson(const {
        'date': '2027-01-03',
        'service': {
          'id': 's1',
          'name': 'Hair Cutting',
          'durationMinutes': 45,
          'priceCents': 4500,
        },
        'slots': <Map<String, dynamic>>[],
        'reason': 'SALON_CLOSED',
      });

      expect(availability.isEmpty, isTrue);
      expect(availability.reason, UnavailableReason.salonClosed);
      expect(availability.reason!.message, 'We are closed that day.');
    });
  });
}
