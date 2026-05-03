class PanditModel {
  final String id;
  final String userId;
  final String name;
  final String? bio;
  final int experienceYears;
  final List<String> languages;
  // specializations removed: the schema stores pandit↔pooja relations in the
  // pandit_poojas join table, not as a TEXT[] column on pandits.
  // Fetch via: supabase.from('pandit_poojas').select('pooja_master(name_en)')
  //            .eq('pandit_id', panditId)
  final double rating;
  final int totalReviews;
  final bool isVerified;
  final double? travelRadiusKm;
  final String? photoUrl;
  final String? city;
  final double? locationLat;
  final double? locationLng;
  final int basePrice;
  final String? phone;

  const PanditModel({
    required this.id,
    required this.userId,
    required this.name,
    this.bio,
    required this.experienceYears,
    required this.languages,
    required this.rating,
    required this.totalReviews,
    required this.isVerified,
    this.travelRadiusKm,
    this.photoUrl,
    this.city,
    this.locationLat,
    this.locationLng,
    required this.basePrice,
    this.phone,
  });

  factory PanditModel.fromMap(Map<String, dynamic> map) {
    return PanditModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String? ?? '',
      bio: map['bio'] as String?,
      experienceYears: (map['experience_years'] as num?)?.toInt() ?? 0,
      languages: List<String>.from(map['languages'] ?? []),
      // specializations column removed from schema — do not read it here.
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (map['total_reviews'] as num?)?.toInt() ?? 0,
      isVerified: map['is_verified'] as bool? ?? false,
      travelRadiusKm: (map['travel_radius_km'] as num?)?.toDouble(),
      photoUrl: map['photo_url'] as String?,
      city: map['city'] as String?,
      locationLat: (map['location_lat'] as num?)?.toDouble(),
      locationLng: (map['location_lng'] as num?)?.toDouble(),
      basePrice: (map['base_price'] as num?)?.toInt() ?? 0,
      phone: map['phone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'bio': bio,
      'experience_years': experienceYears,
      'languages': languages,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_verified': isVerified,
      'travel_radius_km': travelRadiusKm,
      'photo_url': photoUrl,
      'city': city,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'base_price': basePrice,
      'phone': phone,
    };
  }
}

// Demo/seed data for pandits — specializations removed from constructor.
// To display specializations, join pandit_poojas with pooja_master via Supabase.
List<PanditModel> get demoPandits => [
      PanditModel(
        id: 'p1',
        userId: 'u1',
        name: 'Pandit Suresh Sharma',
        bio: 'Expert in Vedic rituals with over 20 years of experience. Specializes in Satyanarayana Puja and marriage ceremonies.',
        experienceYears: 20,
        languages: ['Telugu', 'Sanskrit', 'Hindi'],
        rating: 4.8,
        totalReviews: 312,
        isVerified: true,
        travelRadiusKm: 25,
        photoUrl: null,
        city: 'Hyderabad',
        locationLat: 17.3850,
        locationLng: 78.4867,
        basePrice: 2500,
        phone: '+91 9876543210',
      ),
      PanditModel(
        id: 'p2',
        userId: 'u2',
        name: 'Pandit Anil Joshi',
        bio: 'Specialist in Griha Pravesh, Vastu Shaanti and Navagraha Homam. Fluent in Telugu and Sanskrit.',
        experienceYears: 15,
        languages: ['Telugu', 'Sanskrit'],
        rating: 4.7,
        totalReviews: 198,
        isVerified: true,
        travelRadiusKm: 20,
        photoUrl: null,
        city: 'Hyderabad',
        locationLat: 17.4010,
        locationLng: 78.5000,
        basePrice: 2000,
        phone: '+91 9876543211',
      ),
      PanditModel(
        id: 'p3',
        userId: 'u3',
        name: 'Pandit Ravi Shastri',
        bio: 'Wedding specialist with expertise in traditional Telugu and Tamil ceremonies. 18 years of experience.',
        experienceYears: 18,
        languages: ['Telugu', 'Sanskrit', 'Tamil'],
        rating: 4.9,
        totalReviews: 421,
        isVerified: true,
        travelRadiusKm: 30,
        photoUrl: null,
        city: 'Hyderabad',
        locationLat: 17.3600,
        locationLng: 78.4750,
        basePrice: 3500,
        phone: '+91 9876543212',
      ),
      PanditModel(
        id: 'p4',
        userId: 'u4',
        name: 'Pandit Krishna Murthy',
        bio: 'Expert in Rudrabhishek and Shiva-related poojas. Trained at Kashi with traditional Vedic knowledge.',
        experienceYears: 25,
        languages: ['Telugu', 'Sanskrit', 'Hindi'],
        rating: 4.6,
        totalReviews: 267,
        isVerified: true,
        travelRadiusKm: 15,
        photoUrl: null,
        city: 'Hyderabad',
        locationLat: 17.4100,
        locationLng: 78.5200,
        basePrice: 3000,
        phone: '+91 9876543213',
      ),
      PanditModel(
        id: 'p5',
        userId: 'u5',
        name: 'Pandit Venkat Rao',
        bio: 'Young and dynamic pandit specialized in modern-style traditional ceremonies. Available for all occasions.',
        experienceYears: 8,
        languages: ['Telugu', 'Sanskrit'],
        rating: 4.5,
        totalReviews: 89,
        isVerified: true,
        travelRadiusKm: 20,
        photoUrl: null,
        city: 'Secunderabad',
        locationLat: 17.4399,
        locationLng: 78.4983,
        basePrice: 1500,
        phone: '+91 9876543214',
      ),
    ];
