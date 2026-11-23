/// Every navigable route in the app, in one place.
///
/// This is the single source of truth. An earlier copy of this class also
/// lived in `utils/constants.dart` with a different set of members, which is
/// how `booking`, `services` and `staffDetail` came to be pushed from the home
/// screen while never being registered. Milestone 4 turns these into
/// `go_router` paths; until then they are the names passed to `Navigator`.
class AppRoutes {
  const AppRoutes._();

  // Boot and auth
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  // Client
  static const String home = '/home';
  static const String services = '/services';
  static const String staffDetail = '/staff-detail';
  static const String booking = '/booking';
  static const String bookingConfirmed = '/booking/confirmed';
  static const String appointments = '/appointments';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';

  // Staff (stylist and owner)
  static const String staffAgenda = '/staff/agenda';
  static const String staffSchedule = '/staff/schedule';
  static const String staffServices = '/staff/services';
}
