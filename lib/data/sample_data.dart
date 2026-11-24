import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/appointment.dart';
import '../models/service.dart';
import '../models/stylist.dart';

/// Stand-in data for the UI layer, in the same shapes the API returns.
///
/// The screens read this today and the repositories tomorrow. Because both
/// produce identical models, Sprint 2 swaps the source without touching a
/// single widget.
class SampleData {
  const SampleData._();

  static const String salonId = 'after8';
  static const String salonName = 'After8 Hair Salon';
  static const String salonAddress = '123 Willows Street, Bloemfontein';
  static const String salonPhone = '+27 51 123 4567';
  static const String salonHours = '09:00 – 20:00';

  static const AppUser currentUser = AppUser(
    id: 'u1',
    email: 'jabu@example.com',
    fullName: 'Jabulile Mashibini',
    phone: '+27 51 123 4567',
  );

  static const Service haircut = Service(
    id: 's1',
    name: 'Hair Cutting',
    category: 'Hair Services',
    priceCents: 4500,
    durationMinutes: 45,
    description: 'Cut and style',
  );
  static const Service colouring = Service(
    id: 's2',
    name: 'Hair Coloring',
    category: 'Hair Services',
    priceCents: 18500,
    durationMinutes: 90,
    description: 'Full colour with consultation',
  );
  static const Service facial = Service(
    id: 's3',
    name: 'Facial Treatment',
    category: 'Skincare',
    priceCents: 16500,
    durationMinutes: 60,
    description: 'Deep cleanse and rejuvenation',
  );
  static const Service nails = Service(
    id: 's4',
    name: 'Manicure & Pedicure',
    category: 'Nails',
    priceCents: 15500,
    durationMinutes: 60,
    description: 'Full nail care and polish',
  );

  static const List<Service> services = [haircut, colouring, facial, nails];

  static const List<Stylist> stylists = [
    Stylist(
      id: 'st1',
      userId: 'u-st1',
      fullName: 'Jabulile Mashibini',
      title: 'Senior Stylist',
      specialization: 'Hair cutting & colouring',
      experienceYears: 8,
      rating: 4.9,
      reviewCount: 156,
      services: [haircut, colouring],
    ),
    Stylist(
      id: 'st2',
      userId: 'u-st2',
      fullName: 'Oscar Poco',
      title: 'Beauty Specialist',
      specialization: 'Facial & skincare',
      experienceYears: 6,
      rating: 4.7,
      reviewCount: 98,
      services: [facial],
    ),
    Stylist(
      id: 'st3',
      userId: 'u-st3',
      fullName: 'Sebabatso Molelle',
      title: 'Nail Technician',
      specialization: 'Manicure & pedicure',
      experienceYears: 5,
      rating: 4.8,
      reviewCount: 127,
      services: [nails],
    ),
    Stylist(
      id: 'st4',
      userId: 'u-st4',
      fullName: 'Lwando Ndulula',
      title: 'Makeup Artist',
      specialization: 'Makeup & bridal',
      experienceYears: 7,
      rating: 4.9,
      reviewCount: 142,
      services: [haircut, facial],
    ),
  ];

  /// Dated relative to now, so the demo never shows appointments in the past
  /// the way the old hardcoded 2024 dates did.
  static List<Appointment> get appointments {
    final now = DateTime.now();
    return [
      _make(
        id: 'a1',
        service: haircut,
        stylist: stylists[0],
        startsAt: _at(now.add(const Duration(days: 4)), 14, 0),
        status: AppointmentStatus.confirmed,
      ),
      _make(
        id: 'a2',
        service: facial,
        stylist: stylists[1],
        startsAt: _at(now.add(const Duration(days: 13)), 15, 30),
        status: AppointmentStatus.pending,
      ),
      _make(
        id: 'a3',
        service: colouring,
        stylist: stylists[0],
        startsAt: _at(now.subtract(const Duration(days: 21)), 11, 0),
        status: AppointmentStatus.completed,
      ),
      _make(
        id: 'a4',
        service: nails,
        stylist: stylists[2],
        startsAt: _at(now.subtract(const Duration(days: 40)), 9, 45),
        status: AppointmentStatus.cancelled,
      ),
    ];
  }

  static Appointment _make({
    required String id,
    required Service service,
    required Stylist stylist,
    required DateTime startsAt,
    required AppointmentStatus status,
  }) => Appointment(
    id: id,
    status: status,
    startsAt: startsAt,
    endsAt: startsAt.add(Duration(minutes: service.durationMinutes)),
    durationMinutes: service.durationMinutes,
    priceCents: service.priceCents,
    serviceId: service.id,
    stylistId: stylist.id,
    userId: currentUser.id,
    service: service,
    stylist: AppointmentStylist(
      id: stylist.id,
      fullName: stylist.fullName,
      title: stylist.title,
    ),
  );

  static DateTime _at(DateTime day, int hour, int minute) =>
      DateTime(day.year, day.month, day.day, hour, minute);

  /// Slots a stylist could work. Stands in for `GET /availability`.
  static const List<String> morningSlots = [
    '09:00',
    '09:45',
    '10:30',
    '11:15',
    '12:00',
    '12:45',
  ];

  static const List<String> afternoonSlots = [
    '13:30',
    '14:00',
    '15:00',
    '15:45',
    '16:30',
    '17:15',
  ];

  static const Set<String> takenSlots = {'09:45', '11:15', '15:45'};

  static IconData iconFor(String serviceId) => switch (serviceId) {
    's1' => Icons.content_cut,
    's2' => Icons.water_drop_outlined,
    's3' => Icons.face_retouching_natural_outlined,
    's4' => Icons.brush_outlined,
    _ => Icons.spa_outlined,
  };

  static List<Stylist> stylistsFor(String serviceId) =>
      stylists.where((stylist) => stylist.performs(serviceId)).toList();
}
