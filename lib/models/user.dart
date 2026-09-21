class User {

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.profileImage = '',
    this.role = 'customer',
    this.isActive = true,
  });
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String profileImage;
  final String role;
  final bool isActive;

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    String? role,
    bool? isActive,
  }) => User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );

  @override
  String toString() => 'User(id: $id, fullName: $fullName, email: $email)';
}
