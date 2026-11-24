import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_fadez/utils/money.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(() {
    Intl.defaultLocale = 'en_ZA';
  });

  group('Money.fromCents', () {
    test('drops decimals for whole amounts', () {
      expect(Money.fromCents(4500), contains('45'));
      expect(Money.fromCents(4500), startsWith('R'));
      expect(Money.fromCents(4500), isNot(contains(',00')));
    });

    test('keeps decimals when there are cents', () {
      expect(Money.fromCents(4550), contains('50'));
    });

    test('formats zero', () {
      expect(Money.fromCents(0), startsWith('R'));
      expect(Money.fromCents(0), contains('0'));
    });

    test('never emits a dollar sign', () {
      for (final cents in [0, 1, 4500, 18500, 1234567]) {
        expect(Money.fromCents(cents), isNot(contains(r'$')));
      }
    });
  });

  group('Money.fromRand', () {
    test('matches fromCents for equivalent amounts', () {
      expect(Money.fromRand(45), Money.fromCents(4500));
      expect(Money.fromRand(165.5), Money.fromCents(16550));
    });
  });
}
