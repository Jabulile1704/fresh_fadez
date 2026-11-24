import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../models/service.dart';
import '../models/stylist.dart';
import '../models/user.dart';
import '../utils/constants.dart';

/// Stand-in data for the UI layer.
///
/// This exists so the screens can be built against the typed models rather
/// than the `List<Map<String, dynamic>>` literals that used to sit inside each
/// widget's state. When the REST API lands, the repositories replace this file
/// and the screens do not change.
class SampleData {
  const SampleData._();

  static const String salonId = 'after8';
  static const String salonName = 'After8 Hair Salon';
  static const String salonAddress = '123 Willows Street, Bloemfontein';
  static const String salonPhone = '+27 51 123 4567';
  static const String salonHours = '09:00 – 20:00';

  static const User currentUser = User(
    id: 'u1',
    firstName: 'Jabulile',
    lastName: 'Mashibini',
    email: 'jabu@example.com',
    phone: '+27 51 123 4567',
  );

  static const List<Service> services = [
    Service(
      id: 's1',
      name: 'Hair Cutting',
      description: 'Cut and style',
      category: 'Hair Services',
      price: 45,
      durationMinutes: 45,
      rating: 4.9,
    ),
    Service(
      id: 's2',
      name: 'Hair Coloring',
      description: 'Full colour with consultation',
      category: 'Hair Services',
      price: 185,
      durationMinutes: 90,
      rating: 4.8,
    ),
    Service(
      id: 's3',
      name: 'Facial Treatment',
      description: 'Deep cleanse and rejuvenation',
      category: 'Skincare',
      price: 165,
      durationMinutes: 60,
      rating: 4.7,
    ),
    Service(
      id: 's4',
      name: 'Manicure & Pedicure',
      description: 'Full nail care and polish',
      category: 'Nails',
      price: 155,
      durationMinutes: 60,
      rating: 4.8,
    ),
  ];

  static final List<Stylist> stylists = [
    Stylist(
      id: 'st1',
      salonId: salonId,
      firstName: 'Jabulile',
      lastName: 'Mashibini',
      email: 'jabulile@after8.co.za',
      phone: '+27 51 123 4567',
      createdAt: DateTime(2018, 3, 12),
      specialization: 'Senior Stylist',
      experienceYears: 8,
      rating: 4.9,
      reviewCount: 156,
      services: const ['s1', 's2'],
    ),
    Stylist(
      id: 'st2',
      salonId: salonId,
      firstName: 'Oscar',
      lastName: 'Poco',
      email: 'oscar@after8.co.za',
      phone: '+27 51 123 4568',
      createdAt: DateTime(2020, 6, 15),
      specialization: 'Beauty Specialist',
      experienceYears: 6,
      rating: 4.7,
      reviewCount: 98,
      services: const ['s3'],
    ),
    Stylist(
      id: 'st3',
      salonId: salonId,
      firstName: 'Sebabatso',
      lastName: 'Molelle',
      email: 'sebabatso@after8.co.za',
      phone: '+27 51 123 4569',
      createdAt: DateTime(2021, 2, 8),
      specialization: 'Nail Technician',
      experienceYears: 5,
      rating: 4.8,
      reviewCount: 127,
      services: const ['s4'],
    ),
    Stylist(
      id: 'st4',
      salonId: salonId,
      firstName: 'Lwando',
      lastName: 'Ndulula',
      email: 'lwando@after8.co.za',
      phone: '+27 51 123 4570',
      createdAt: DateTime(2019, 9, 23),
      specialization: 'Makeup Artist',
      experienceYears: 7,
      rating: 4.9,
      reviewCount: 142,
      services: const ['s1', 's3'],
    ),
  ];

  /// Dated relative to now, so the demo never shows appointments in the past
  /// the way the old hardcoded 2024 dates did.
  static List<Appointment> get appointments {
    final now = DateTime.now();
    return [
      Appointment(
        id: 'a1',
        userId: currentUser.id,
        salonId: salonId,
        serviceName: 'Hair Cutting',
        stylistName: 'Jabulile Mashibini',
        appointmentDate: now.add(const Duration(days: 4)),
        appointmentTime: '14:00',
        status: AppointmentStatus.confirmed,
        totalPrice: 45,
      ),
      Appointment(
        id: 'a2',
        userId: currentUser.id,
        salonId: salonId,
        serviceName: 'Facial Treatment',
        stylistName: 'Oscar Poco',
        appointmentDate: now.add(const Duration(days: 13)),
        appointmentTime: '15:30',
        status: AppointmentStatus.pending,
        totalPrice: 165,
      ),
      Appointment(
        id: 'a3',
        userId: currentUser.id,
        salonId: salonId,
        serviceName: 'Hair Coloring',
        stylistName: 'Jabulile Mashibini',
        appointmentDate: now.subtract(const Duration(days: 21)),
        appointmentTime: '11:00',
        status: AppointmentStatus.completed,
        totalPrice: 185,
      ),
      Appointment(
        id: 'a4',
        userId: currentUser.id,
        salonId: salonId,
        serviceName: 'Manicure & Pedicure',
        stylistName: 'Sebabatso Molelle',
        appointmentDate: now.subtract(const Duration(days: 40)),
        appointmentTime: '09:45',
        status: AppointmentStatus.cancelled,
        totalPrice: 155,
      ),
    ];
  }

  /// Slots a stylist could work. The booked set stands in for what
  /// `GET /availability` will return once the API is wired up.
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

  static List<Stylist> stylistsFor(String serviceId) => stylists
      .where((stylist) => stylist.services.contains(serviceId))
      .toList();
}
