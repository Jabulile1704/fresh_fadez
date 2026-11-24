import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/appointment.dart';
import '../models/booking_draft.dart';
import '../models/service.dart';
import '../routes/app_routes.dart';
import '../screens/appointment_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/services_screen.dart';
import '../utils/constants.dart';
import 'glass_bottom_nav.dart';

/// The signed-in shell: four tabs behind a floating glass bar, with the
/// booking flow pushed over the top of it.
///
/// It replaces `AppNavigationWrapper`, which was never reachable and returned
/// `HomeScreen` for every tab index.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const List<GlassNavItem> _navItems = [
    GlassNavItem(icon: Icons.home_outlined, label: 'Home'),
    GlassNavItem(icon: Icons.content_cut, label: 'Services'),
    GlassNavItem(icon: Icons.calendar_today_outlined, label: 'Bookings'),
    GlassNavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  int _index = 0;
  late List<Appointment> _appointments = SampleData.appointments;

  /// Runs the two-step flow and folds the result back into the list.
  ///
  /// Until the API lands this only updates local state — nothing is persisted,
  /// so a restart brings back the sample bookings.
  Future<void> _startBooking([Service? service]) async {
    final draft = await Navigator.of(context).push<BookingDraft>(
      MaterialPageRoute<BookingDraft>(
        builder: (context) => BookingScreen(initialService: service),
      ),
    );
    if (draft == null || !draft.isComplete || !mounted) {
      return;
    }

    final booked = Appointment(
      id: 'new-${DateTime.now().millisecondsSinceEpoch}',
      userId: SampleData.currentUser.id,
      salonId: SampleData.salonId,
      serviceName: draft.service!.name,
      stylistName: draft.stylistLabel,
      appointmentDate: draft.date!,
      appointmentTime: draft.time!,
      status: AppointmentStatus.pending,
      totalPrice: draft.service!.price,
    );

    setState(() {
      _appointments = [booked, ..._appointments];
      _index = 2;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
            content: Text('${AppMessages.bookingSuccess} — '
                'the salon will confirm shortly.')),
      );
  }

  Future<void> _cancel(Appointment appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this booking?'),
        content: Text(
          '${appointment.serviceName} with ${appointment.stylistName} on '
          '${appointment.formattedDate} at ${appointment.appointmentTime}.\n\n'
          'Cancelling inside 24 hours may be charged.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _appointments = [
        for (final a in _appointments)
          if (a.id == appointment.id)
            Appointment(
              id: a.id,
              userId: a.userId,
              salonId: a.salonId,
              serviceName: a.serviceName,
              stylistName: a.stylistName,
              appointmentDate: a.appointmentDate,
              appointmentTime: a.appointmentTime,
              status: AppointmentStatus.cancelled,
              totalPrice: a.totalPrice,
              notes: a.notes,
            )
          else
            a,
      ];
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Booking cancelled.')));
  }

  void _signOut() => Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            IndexedStack(
              index: _index,
              children: [
                HomeScreen(
                  appointments: _appointments,
                  onStartBooking: _startBooking,
                  onSeeAllServices: () => setState(() => _index = 1),
                ),
                ServicesScreen(onStartBooking: _startBooking),
                AppointmentsScreen(
                  appointments: _appointments,
                  onReschedule: (appointment) => _startBooking(),
                  onCancel: _cancel,
                  onStartBooking: _startBooking,
                ),
                ProfileScreen(
                  appointments: _appointments,
                  onSignOut: _signOut,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GlassBottomNav(
                items: _navItems,
                currentIndex: _index,
                onTabSelected: (index) => setState(() => _index = index),
                onBookPressed: _startBooking,
              ),
            ),
          ],
        ),
      );
}
