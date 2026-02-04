class Service {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int durationMinutes;
  final double rating;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.durationMinutes,
    this.rating = 0.0,
  });

  String get formattedPrice => '\$$price';

  String get formattedDuration {
    if (durationMinutes < 60) {
      return '${durationMinutes}min';
    } else {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      if (minutes == 0) {
        return '${hours}h';
      }
      return '${hours}h ${minutes}min';
    }
  }

  @override
  String toString() => 'Service(id: $id, name: $name, price: $price)';
}