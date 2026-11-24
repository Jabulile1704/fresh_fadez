import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/api_client.dart';
import '../data/api/token_store.dart';
import '../data/repositories/appointment_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/availability_repository.dart';
import '../data/repositories/catalog_repository.dart';
import '../models/app_user.dart';
import '../models/appointment.dart';
import '../models/availability.dart';
import '../models/salon.dart';
import '../models/service.dart';
import '../models/stylist.dart';

/// The wiring. Every repository is reachable from here and nowhere else, so
/// a widget never constructs its own client.
///
/// This file replaces `providers/state_management.dart`, which was 0 bytes.

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore.standard());

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    tokenStore: ref.watch(tokenStoreProvider),
    onSessionExpired: () => ref.invalidate(authControllerProvider),
  );
  return client;
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    client: ref.watch(apiClientProvider),
    tokens: ref.watch(tokenStoreProvider),
  ),
);

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepository(ref.watch(apiClientProvider)),
);

final availabilityRepositoryProvider = Provider<AvailabilityRepository>(
  (ref) => AvailabilityRepository(ref.watch(apiClientProvider)),
);

final appointmentRepositoryProvider = Provider<AppointmentRepository>(
  (ref) => AppointmentRepository(ref.watch(apiClientProvider)),
);

/// Who is signed in. `null` means nobody; the router keys off this.
class AuthController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() => ref.watch(authRepositoryProvider).currentUser();

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .login(email: email, password: password),
    );
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .register(
            fullName: fullName,
            email: email,
            phone: phone,
            password: password,
          ),
    );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AppUser?>(
  AuthController.new,
);

final servicesProvider = FutureProvider<List<Service>>(
  (ref) => ref.watch(catalogRepositoryProvider).services(),
);

final stylistsProvider = FutureProvider<List<Stylist>>(
  (ref) => ref.watch(catalogRepositoryProvider).stylists(),
);

final salonProvider = FutureProvider<SalonInfo>(
  (ref) => ref.watch(catalogRepositoryProvider).salon(),
);

/// The arguments one availability lookup needs.
class AvailabilityQuery {
  const AvailabilityQuery({
    required this.serviceId,
    required this.date,
    this.stylistId,
  });

  final String serviceId;
  final DateTime date;
  final String? stylistId;

  @override
  bool operator ==(Object other) =>
      other is AvailabilityQuery &&
      other.serviceId == serviceId &&
      other.stylistId == stylistId &&
      other.date.year == date.year &&
      other.date.month == date.month &&
      other.date.day == date.day;

  @override
  int get hashCode =>
      Object.hash(serviceId, stylistId, date.year, date.month, date.day);
}

final availabilityProvider =
    FutureProvider.family<Availability, AvailabilityQuery>(
      (ref, query) => ref
          .watch(availabilityRepositoryProvider)
          .forDay(
            serviceId: query.serviceId,
            date: query.date,
            stylistId: query.stylistId,
          ),
    );

final appointmentsProvider = FutureProvider<List<Appointment>>(
  (ref) => ref.watch(appointmentRepositoryProvider).list(),
);
