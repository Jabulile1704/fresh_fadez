class Stylist {

  Stylist({
    required this.id,
    required this.salonId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.createdAt, this.profileImage = '',
    this.specialization = '',
    this.experienceYears = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.services = const [],
    this.availableDays = const [],
    this.startTime = '09:00',
    this.endTime = '18:00',
    this.isAvailable = true,
    this.bio = '',
    this.totalClients = 0,
  });

  // Convert from JSON
  factory Stylist.fromJson(Map<String, dynamic> json) => Stylist(
      id: json['id'] ?? '',
      salonId: json['salonId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      specialization: json['specialization'] ?? '',
      experienceYears: json['experienceYears'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      services: List<String>.from(json['services'] ?? []),
      availableDays: List<String>.from(json['availableDays'] ?? []),
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '18:00',
      isAvailable: json['isAvailable'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      bio: json['bio'] ?? '',
      totalClients: json['totalClients'] ?? 0,
    );
  final String id;
  final String salonId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String profileImage;
  final String specialization;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final List<String> services;
  final List<String> availableDays;
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final DateTime createdAt;
  final String bio;
  final int totalClients;

  // Full name getter
  String get fullName => '$firstName $lastName';

  // Copy with method
  Stylist copyWith({
    String? id,
    String? salonId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    String? specialization,
    int? experienceYears,
    double? rating,
    int? reviewCount,
    List<String>? services,
    List<String>? availableDays,
    String? startTime,
    String? endTime,
    bool? isAvailable,
    DateTime? createdAt,
    String? bio,
    int? totalClients,
  }) => Stylist(
      id: id ?? this.id,
      salonId: salonId ?? this.salonId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      specialization: specialization ?? this.specialization,
      experienceYears: experienceYears ?? this.experienceYears,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      services: services ?? this.services,
      availableDays: availableDays ?? this.availableDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      bio: bio ?? this.bio,
      totalClients: totalClients ?? this.totalClients,
    );

  // Convert to JSON
  Map<String, dynamic> toJson() => {
      'id': id,
      'salonId': salonId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'specialization': specialization,
      'experienceYears': experienceYears,
      'rating': rating,
      'reviewCount': reviewCount,
      'services': services,
      'availableDays': availableDays,
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'bio': bio,
      'totalClients': totalClients,
    };

  @override
  String toString() => 'Stylist(id: $id, fullName: $fullName, specialization: $specialization, rating: $rating)';
}
