class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String role;
  final String? avatarUrl;
  final String? city;
  final double? locationLat;
  final double? locationLng;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    this.avatarUrl,
    this.city,
    this.locationLat,
    this.locationLng,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String?,
      role: map['role'] as String? ?? 'devotee',
      avatarUrl: map['avatar_url'] as String?,
      city: map['city'] as String?,
      locationLat: (map['location_lat'] as num?)?.toDouble(),
      locationLng: (map['location_lng'] as num?)?.toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'avatar_url': avatarUrl,
      'city': city,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    String? city,
    double? locationLat,
    double? locationLng,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      phone: phone,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      createdAt: createdAt,
    );
  }
}
