class Salon {

  const Salon({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.phone,
    this.imageUrl = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isOpen = true,
    this.services = const [],
  });
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String phone;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final List<String> services;

  String get fullAddress => '$address, $city';

  @override
  String toString() => 'Salon(id: $id, name: $name, city: $city)';
}
