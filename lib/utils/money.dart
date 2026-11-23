import 'package:intl/intl.dart';

/// Currency formatting for the app.
///
/// Fresh Fadez trades in South African Rand. Before this existed, the models
/// returned US dollars (`Service.formattedPrice` emitted `'\$$price'`) while
/// every screen hardcoded strings like `'R45'` — so the same price could be
/// shown two different ways depending on where it came from.
///
/// Prices cross the API as integer cents to avoid floating-point drift, so
/// [fromCents] is the usual entry point.
class Money {
  const Money._();

  static final NumberFormat _whole = NumberFormat.currency(
    locale: 'en_ZA',
    symbol: 'R',
    decimalDigits: 0,
  );

  static final NumberFormat _exact = NumberFormat.currency(
    locale: 'en_ZA',
    symbol: 'R',
    decimalDigits: 2,
  );

  /// Formats [cents] as Rand, e.g. `4500` becomes `R4 500`.
  ///
  /// Whole amounts drop the decimals, since salon prices are nearly always
  /// round numbers and `R45` reads better than `R45,00` on a price card.
  static String fromCents(int cents) {
    final rand = cents / 100;
    return rand == rand.roundToDouble() ? _whole.format(rand) : _exact.format(rand);
  }

  /// Formats an amount already expressed in Rand.
  static String fromRand(num rand) =>
      rand == rand.roundToDouble() ? _whole.format(rand) : _exact.format(rand);
}
