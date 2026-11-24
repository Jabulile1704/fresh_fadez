import 'package:freezed_annotation/freezed_annotation.dart';

part 'service.freezed.dart';
part 'service.g.dart';

/// A bookable service, exactly as `servicePublic` on the API returns it.
///
/// Money is `priceCents` rather than a double: a salon price in Rand is an
/// exact amount, and floating point is the wrong tool for exact amounts.
@freezed
abstract class Service with _$Service {
  const factory Service({
    required String id,
    required String name,
    required String category,
    required int priceCents,
    required int durationMinutes,
    @Default('') String description,
    String? imageAsset,
    @Default(true) bool active,
  }) = _Service;

  const Service._();

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  /// `45min`, `1h`, `1h 30min`.
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '${durationMinutes}min';
    }
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    return minutes == 0 ? '${hours}h' : '${hours}h ${minutes}min';
  }
}
